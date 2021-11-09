require 'queuery_client/data_file_bundle'
require 'queuery_client/s3_data_file'
require 'queuery_client/s3_manifest_file'
require 'aws-sdk-s3'
require 'logger'

module QueueryClient
  class S3DataFileBundle < DataFileBundle
    def initialize(bucket, prefix, s3_client: nil, logger: Logger.new($stderr))
      @s3_client = s3_client || Aws::S3::Client.new   # Use env to inject credentials
      @bucket = bucket
      @prefix = prefix
      @logger = logger
    end

    attr_reader :bucket
    attr_reader :prefix
    attr_reader :logger

    def url
      "s3://#{@bucket}/#{@prefix}"
    end

    def data_files
      b = Aws::S3::Resource.new(client: @s3_client).bucket(@bucket)
      b.objects(prefix: @prefix)
        .select {|obj| obj.key.include?('_part_') }
        .map {|obj| S3DataFile.new(obj) }
    end

    def manifest_file
      b = Aws::S3::Resource.new(client: @s3_client).bucket(@bucket)
      obj = b.object("#{@prefix}manifest")
      if obj.exists?
        S3ManifestFile.new(obj)
      else
        nil
      end
    end

    def has_manifest?
      !manifest_file.nil?
    end
  end
end
