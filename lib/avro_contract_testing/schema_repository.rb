# frozen_string_literal: true

require 'avro_turf'
require 'fog-aws'
require 'avro_contract_testing/consumer'
require 'avro_contract_testing/producer'

module AvroContractTesting
  class SchemaRepository
    class << self
      ROLES = %w[producer consumer].freeze

      def upload(schema_name, role = 'consumer')
        raise 'Schema role must be either producer or consumer' unless ROLES.include?(role)

        files = storage.directories.get(config.s3_bucket_name).files
        schema_store = AvroTurf::SchemaStore.new(path: config.schema_path)

        files.create(
          key: "#{role}/#{schema_name}/#{config.application_name}.avsc",
          body: schema_store.find(schema_name).to_s,
          public: false,
          content_type: 'application/json'
        )
      end

      def storage
        Fog::Storage.new(
          provider: 'AWS',
          aws_access_key_id: config.aws_access_key_id,
          aws_secret_access_key: config.aws_secret_access_key,
          region: config.region
        )
      end

      def consumers(schema_name)
        files = storage.directories.get(config.s3_bucket_name).files

        # TODO: remove without-prefix logic once all schemas are moved over to the prefix convention
        schemas_without_prefix = files.all(prefix: schema_name + '/').map do |schema_file|
          application_name = application_name(schema_file.key)
          AvroContractTesting::Consumer.new(application_name: application_name, schema: schema_file.body)
        end

        schemas_with_prefix = files.all(prefix: 'consumer/' + schema_name + '/').map do |schema_file|
          application_name = application_name(schema_file.key)
          AvroContractTesting::Consumer.new(application_name: application_name, schema: schema_file.body)
        end
        [schemas_with_prefix, schemas_without_prefix].flatten
      end

      def producers(schema_name)
        files = storage.directories.get(config.s3_bucket_name).files

        files.all(prefix: 'producer/' + schema_name + '/').map do |schema_file|
          producer_name = application_name(schema_file.key)
          AvroContractTesting::Producer.new(application_name: producer_name, schema: schema_file.body)
        end
      end

      private

      def config
        AvroContractTesting.configuration
      end

      def application_name(key)
        key[%r{([^/]*).avsc$}].chomp('.avsc')
      end
    end
  end
end
