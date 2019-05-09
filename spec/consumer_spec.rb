require 'avro_contract_testing/consumer'

describe AvroContractTesting::Consumer do
  describe '#compatible?' do
    subject { described_class.new(name: 'test_name', schema: consumer_schema) }

    context 'with identical schemas' do
      let(:consumer_schema) { '{"name":"test","type":"record","fields":[]}' }
      it { is_expected.to be_compatible(consumer_schema) }
    end

    context 'with additional field on consumer' do
      let(:producer_schema) { '{"name":"test","type":"record","fields":[]}' }
      let(:consumer_schema) { '{"name":"test","type":"record","fields":[{"name":"id","type":"int"}]}' }
      it { is_expected.not_to be_compatible(producer_schema) }
    end

    context 'with less fields on consumer' do
      let(:producer_schema) { '{"name":"test","type":"record","fields":[{"name":"id","type":"int"}]}' }
      let(:consumer_schema) { '{"name":"test","type":"record","fields":[]}' }
      it { is_expected.to be_compatible(producer_schema) }
    end
  end
end
