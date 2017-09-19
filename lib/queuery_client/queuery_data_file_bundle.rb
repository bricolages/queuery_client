require 'redshift_connector/url_data_file_bundle'

module QueueryClient
  class QueueryDataFileBundle < RedshiftConnector::UrlDataFileBundle
    def url
      uri = data_files.first.url.dup
      uri.query = nil
      uri.path = File.dirname(uri.path)
      uri.to_s
    end
  end
end
