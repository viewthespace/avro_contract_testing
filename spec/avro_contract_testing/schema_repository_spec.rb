# frozen_string_literal: true

require 'avro_contract_testing/schema_repository'
require 'avro_contract_testing/configuration'

describe AvroContractTesting::SchemaRepository do
  let(:storage) { described_class.storage }
  let(:s3_bucket_name) { 'test_bucket_name' }
  let(:schema_path) { Pathname.new(File.expand_path(__dir__)).join('../fixtures/schemas') }
  let(:application_name) { 'test_app_name' }
  let(:access_key_id) { 'test_id' }
  let(:access_key) { 'test_key' }

  before do
    AvroContractTesting.configure do |config|
      config.s3_bucket_name = s3_bucket_name
      config.schema_path = schema_path
      config.application_name = application_name
      config.aws_access_key_id = access_key_id
      config.aws_secret_access_key = access_key
    end

    Fog.mock!
    storage.directories.create(key: s3_bucket_name)
  end

  after do
    Fog.unmock!
    AvroContractTesting.reset
  end

  describe '.upload' do
    it 'uploads a schema to s3' do
      described_class.upload('test')

      expected_contract = "test/#{application_name}.avsc"
      uploaded_schema = storage
        .directories.get(s3_bucket_name)
        .files.get(expected_contract)
        .body

      alias_schema = '{"type":"record","name":"test_alias","fields":[{"name":"id","type":"int"}]}'
      full_schema = '{"type":"record","name":"test","fields":[{"name":"id","type":"int"},{"name":"test_alias","type":' + alias_schema + '}]}'
      expect(uploaded_schema).to eq full_schema
    end
  end

  describe '.consumers' do
    let(:schema_body) { '{"name":"test","type":"record","fields":[]}' }

    before do
      storage.directories.get(s3_bucket_name).files.create(
        key: 'test_producer_schema_name/test_consumer_application.avsc',
        body: schema_body,
        public: false,
        content_type: 'application/json'
      )
    end

    subject(:consumer) { described_class.consumers('test_producer_schema_name').first }

    it { is_expected.to be_a(AvroContractTesting::Consumer) }
    it { expect(consumer.name).to eq 'test_consumer_application' }
    it { expect(consumer.schema).to eq(Avro::Schema.parse(schema_body)) }
  end
end
