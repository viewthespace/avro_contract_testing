# AvroContractTesting

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'avro_contract_testing', git: 'https://github.com/viewthespace/avro_contract_testing.git'
```

And then execute:

    $ bundle

## Usage

#### 1. Configuration
Options to be configured on application boot:

```
AvroContractTesting.configure do |config|
  config.s3_bucket_name = <<s3_bucket_name>>
  config.application_name = <<application_name>>
  config.aws_access_key_id = <<aws_access_key_id>>
  config.aws_secret_access_key = <<aws_scecret_key>>
  config.schema_path = <<path_to_schemas_path>>
end
``` 

#### 2. Example producer application testing consumer schemas for compatibility:
```
describe 'test schema' do
 let(:producer_schema) { AvroTurf::SchemaStore.new(path: SCHEMA_PATH).find('test_schema').to_s }

 AvroContractTesting::SchemaRepository.consumers('test_schema').each do |consumer|
   it "is compatible with consumer: #{consumer.name}" do
     expect(consumer).to be_compatible(producer_schema)
   end
 end
end
```

#### 3. How to upload consumer schema to s3 bucket:
`AvroContractTesting:SchemaRespostiory.upload(<<schema_name>>)`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec && rubocop` to run the tests and linter. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
