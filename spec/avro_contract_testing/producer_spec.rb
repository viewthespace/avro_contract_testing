# frozen_string_literal: true

require 'avro_contract_testing/producer'

describe AvroContractTesting::Producer do
  describe '#compatible?' do
    subject(:producer) { described_class.new(application_name: 'test_name', schema: producer_schema) }

    context 'with identical schemas' do
      let(:producer_schema) { '{"name":"test","type":"record","fields":[]}' }
      it { is_expected.to be_compatible(producer_schema) }
    end

    context 'with additional fields on the consumer' do
      let(:producer_schema) { '{"name":"test","type":"record","fields":[]}' }
      let(:consumer_schema) { '{"name":"test","type":"record","fields":[{"name":"id","type":"int"}]}' }
      it { is_expected.not_to be_compatible(consumer_schema) }
    end

    context 'with additional fields on the producer' do
      let(:producer_schema) { '{"name":"test","type":"record","fields":[{"name":"id","type":"int"}]}' }
      let(:consumer_schema) { '{"name":"test","type":"record","fields":[]}' }
      it { is_expected.to be_compatible(consumer_schema) }
    end
  end
end
