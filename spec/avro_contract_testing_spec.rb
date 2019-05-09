describe AvroContractTesting do
  describe ".configure" do
    subject { AvroContractTesting.configuration }

    before do
      AvroContractTesting.configure do |config|
        config.s3_bucket_name = 'test_bucket_name'
        config.schema_path = 'test_schema_path'
      end
    end

    after do
      AvroContractTesting.reset
    end

    it 'sets configuration values' do
      expect(subject.s3_bucket_name).to eq 'test_bucket_name'
      expect(subject.schema_path).to eq 'test_schema_path'
    end
  end
end
