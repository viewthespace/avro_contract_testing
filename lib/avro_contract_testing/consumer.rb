# frozen_string_literal: true

require 'avro_turf'
require 'avro-patches'

module AvroContractTesting
  class Consumer
    attr_reader :name, :schema

    def initialize(name:, schema:)
      @name = name
      @schema = Avro::Schema.parse(schema)
    end

    def compatible?(producer_schema)
      writer_schema = Avro::Schema.parse(producer_schema)
      Avro::SchemaCompatibility.can_read?(writer_schema, schema)
    end
  end
end
