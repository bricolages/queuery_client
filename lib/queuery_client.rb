require "redshift-connector/url_data_file_bundle"
require "queuery_client/version"
require "queuery_client/client"

module QueueryClient
  class << self
    attr_accessor :endpoint

    def query(select_stmt)
      client = Client.new(endpoint)
      query = client.query_and_wait(select_stmt)
      RedshiftConnector::UrlDataFileBundle.new(query.data_file_urls)
    end
  end
end
