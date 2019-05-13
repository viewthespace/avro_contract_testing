# frozen_string_literal: true

describe AvroContractTesting do
  describe '.configure' do
    subject(:configuration) { described_class.configuration }

    before do
      described_class.configure do |config|
        config.s3_bucket_name = 'test_bucket_name'
        config.schema_path = 'test_schema_path'
      end
    end

    after do
      described_class.reset
    end

    it 'sets configuration values' do
      expect(configuration.s3_bucket_name).to eq 'test_bucket_name'
      expect(configuration.schema_path).to eq 'test_schema_path'
    end
  end
end
