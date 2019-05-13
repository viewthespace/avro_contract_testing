# frozen_string_literal: true

module AvroContractTesting
  class Configuration
    attr_accessor :s3_bucket_name,
      :schema_path,
      :application_name,
      :aws_access_key_id,
      :aws_secret_access_key
  end
end
