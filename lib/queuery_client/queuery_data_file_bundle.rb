require 'redshift_connector/url_data_file_bundle'
require 'redshift_connector/s3_bucket'
require 'redshift_connector/s3_data_file_bundle'
require 'uri'

module QueueryClient
  class QueueryDataFileBundle < RedshiftConnector::UrlDataFileBundle
    def initialize(url, s3_prefix:, **args)
      super(url, **args)
      @s3_prefix = s3_prefix
    end

    attr_reader :s3_prefix

    def url
      uri = data_files.first.url.dup
      uri.query = nil
      uri.path = File.dirname(uri.path)
      uri.to_s
    end

    def direct(bucket_opts = {}, bundle_opts = {})
      s3_uri = URI.parse(s3_prefix)
      bucket_name = s3_uri.host
      prefix = s3_uri.path[1..-1] # trim heading slash
      bucket = RedshiftConnector::S3Bucket.new(bucket: bucket_name, prefix: prefix)
      RedshiftConnector::S3DataFileBundle.new(bucket, prefix, format: :redshift_csv)
    end
  end
end
