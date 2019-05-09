require 'avro_turf'
require 'fog-aws'

module AvroContractTesting
  class SchemaRepository
    class << self
      def upload(schema_name)
        files = storage.directories.get(config.s3_bucket_name).files
        schema_store = AvroTurf::SchemaStore.new(path: config.schema_path)

        files.create(
          key: "#{schema_name}/#{config.application_name}.avsc",
          body: schema_store.find(schema_name).to_s,
          public: false,
          content_type: 'application/json'
        )
      end

      def storage
        Fog::Storage.new(
          provider: 'AWS',
          aws_access_key_id: config.aws_access_key_id,
          aws_secret_access_key: config.aws_secret_access_key
        )
      end

      private

      def config
        AvroContractTesting.configuration
      end
    end
  end
end
