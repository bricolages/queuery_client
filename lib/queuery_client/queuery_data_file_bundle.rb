require 'uri'

module QueueryClient
  class QueueryDataFileBundle < RedshiftConnector::UrlDataFileBundle
    def url
      uri = URI.parse(@data_file_urls.first)
      uri.query = ""
      uri.path = File.dirname(uri.path)
      uri.to_s
    end
  end
end
