# frozen_string_literal: true

require 'avro_turf'

module AvroContractTesting
  class Producer
    attr_reader :application_name, :schema

    def initialize(application_name:, schema:)
      @application_name = application_name
      @schema = Avro::Schema.parse(schema)
    end

    def compatible?(consumer_schema)
      reader_schema = Avro::Schema.parse(consumer_schema)
      Avro::SchemaCompatibility.can_read?(schema, reader_schema)
    end
  end
end
