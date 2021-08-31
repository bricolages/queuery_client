require 'queuery_client/data_file_bundle'
require 'queuery_client/url_data_file'
require 'queuery_client/url_manifest_file'
require 'uri'
require 'logger'

module QueueryClient
  class UrlDataFileBundle < DataFileBundle
    def initialize(data_urls, manifest_url, s3_prefix:, logger: Logger.new($stderr))
      raise ArgumentError, 'no URL given' if data_urls.empty?
      @data_files = data_urls.map {|url| UrlDataFile.new(URI.parse(url)) }
      @manifest_file = UrlManifestFile.new(URI.parse(manifest_url)) if manifest_url
      @s3_prefix = s3_prefix
      @logger = logger
    end

    attr_reader :data_files
    attr_reader :manifest_file
    attr_reader :s3_prefix
    attr_reader :logger

    def url
      uri = data_files.first.url.dup
      uri.query = nil
      uri.path = File.dirname(uri.path)
      uri.to_s
    end

    def direct(bucket_opts = {}, bundle_opts = {})
      s3_uri = URI.parse(s3_prefix)
      bucket = s3_uri.host
      prefix = s3_uri.path[1..-1] # trim heading slash
      S3DataFileBundle.new(bucket, prefix)
    end

    def has_manifest?
      !@manifest_file.nil?
    end
  end
end
