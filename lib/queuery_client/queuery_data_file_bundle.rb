require 'redshift_connector/url_data_file_bundle'

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
  end
end
