# AvroContractTesting

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'avro_contract_testing', git: 'https://github.com/viewthespace/avro_contract_testing.git'
```

And then execute:

    $ bundle

## Usage

### Configuration
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/avro_contract_testing.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
