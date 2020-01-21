# frozen_string_literal: true

require 'avro_contract_testing/schema_repository'
require 'avro_contract_testing/configuration'

describe AvroContractTesting::SchemaRepository do
  let(:storage) { described_class.storage }
  let(:s3_bucket_name) { 'test_bucket_name' }
  let(:schema_path) { Pathname.new(File.expand_path(__dir__)).join('../fixtures/schemas') }
  let(:application_name) { 'test_app_name' }
  let(:producer_role) { 'producer' }
  let(:consumer_role) { 'consumer' }
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
    storage.directories.get(s3_bucket_name).destroy!
    Fog.unmock!
    AvroContractTesting.reset
  end

  describe '.upload' do
    it 'uploads a consumer schema to s3' do
      described_class.upload('test', consumer_role)

      expected_contract = "#{consumer_role}/test/#{application_name}.avsc"
      uploaded_schema = storage
        .directories.get(s3_bucket_name)
        .files.get(expected_contract)
        .body

      alias_schema = '{"type":"record","name":"test_alias","fields":[{"name":"id","type":"int"}]}'
      full_schema = '{"type":"record","name":"test","fields":[{"name":"id","type":"int"},{"name":"test_alias","type":' + alias_schema + '}]}'
      expect(uploaded_schema).to eq full_schema
    end

    it 'uploads a producer schema to s3' do
      described_class.upload('test', producer_role)

      expected_contract = "#{producer_role}/test/#{application_name}.avsc"
      uploaded_schema = storage
        .directories.get(s3_bucket_name)
        .files.get(expected_contract)
        .body

      alias_schema = '{"type":"record","name":"test_alias","fields":[{"name":"id","type":"int"}]}'
      full_schema = '{"type":"record","name":"test","fields":[{"name":"id","type":"int"},{"name":"test_alias","type":' + alias_schema + '}]}'
      expect(uploaded_schema).to eq full_schema
    end

    it 'assumes schema role is consumer if not specified' do
      described_class.upload('test')

      expected_contract = "#{consumer_role}/test/#{application_name}.avsc"
      uploaded_schema = storage
        .directories.get(s3_bucket_name)
        .files.get(expected_contract)
        .body

      alias_schema = '{"type":"record","name":"test_alias","fields":[{"name":"id","type":"int"}]}'
      full_schema = '{"type":"record","name":"test","fields":[{"name":"id","type":"int"},{"name":"test_alias","type":' + alias_schema + '}]}'
      expect(uploaded_schema).to eq full_schema
    end

    it 'raises error if role is not consumer or producer' do
      expect { described_class.upload('test', 'banana') }.to raise_error(
        'Schema role must be either producer or consumer'
      )
    end
  end

  describe '.consumers' do
    let(:consumer_schema_body) { '{"name":"consumer test","type":"record","fields":[]}' }
    let(:producer_schema_body) { '{"name":"producer test","type":"record","fields":[]}' }

    before do
      storage.directories.get(s3_bucket_name).files.create(
        key: 'test_schema_name/test_application.avsc',
        body: consumer_schema_body,
        public: false,
        content_type: 'application/json'
      )
    end

    subject(:consumer) { described_class.consumers('test_schema_name').first }

    it { is_expected.to be_a(AvroContractTesting::Consumer) }
    it { expect(consumer.application_name).to eq 'test_application' }
    it { expect(consumer.schema).to eq(Avro::Schema.parse(consumer_schema_body)) }

    context 'when there is an identical file with a consumer prefix' do
      before do
        storage.directories.get(s3_bucket_name).files.create(
          key: "#{consumer_role}/test_schema_name/test_application.avsc",
          body: consumer_schema_body,
          public: false,
          content_type: 'application/json'
        )
      end

      it 'retrieves both consumers from s3 with and without the prefix' do
        expect(described_class.consumers('test_schema_name').length).to eq 2
      end
    end

    context 'when there are consumers and producers for the same schema' do
      before do
        storage.directories.get(s3_bucket_name).files.create(
          key: "#{producer_role}/test_schema_name/test_application.avsc",
          body: producer_schema_body,
          public: false,
          content_type: 'application/json'
        )
      end

      let(:consumer) { described_class.consumers('test_schema_name').first }

      it 'only retrieves the consumer schema' do
        expect(consumer.schema.name).to eq(Avro::Schema.parse(consumer_schema_body).name)
        expect(described_class.consumers('test_schema_name').length).to eq 1
      end
    end
  end

  describe '.producers' do
    let(:consumer_schema_body) { '{"name":"consumer test","type":"record","fields":[]}' }
    let(:producer_schema_body) { '{"name":"producer test","type":"record","fields":[]}' }

    before do
      storage.directories.get(s3_bucket_name).files.create(
        key: "#{producer_role}/test_schema_name/test_application.avsc",
        body: producer_schema_body,
        public: false,
        content_type: 'application/json'
      )
    end

    subject(:producer) { described_class.producers('test_schema_name').first }

    it { is_expected.to be_a(AvroContractTesting::Producer) }
    it { expect(producer.application_name).to eq 'test_application' }
    it { expect(producer.schema).to eq(Avro::Schema.parse(producer_schema_body)) }

    context 'when there are consumers and producers for the same schema' do
      before do
        storage.directories.get(s3_bucket_name).files.create(
          key: "#{consumer_role}/test_schema_name/test_application.avsc",
          body: consumer_schema_body,
          public: false,
          content_type: 'application/json'
        )
      end

      let(:producer) { described_class.producers('test_schema_name').first }

      it 'only retrieves the producer schema' do
        expect(producer.schema.name).to eq(Avro::Schema.parse(producer_schema_body).name)
        expect(described_class.producers('test_schema_name').length).to eq 1
      end
    end
  end
end
