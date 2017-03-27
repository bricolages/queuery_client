require "redshift-connector/url_data_file_bundle"
require "queuery_client/version"
require "queuery_client/configuration"
require "queuery_client/basic_auth_garage_client"
require "queuery_client/query_error"
require "queuery_client/client"

module QueueryClient
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure(&block)
      configuration.instance_eval(&block)
    end

    def query(select_stmt)
      client = Client.new
      query = client.query_and_wait(select_stmt)
      case query.status
      when 'success'
        RedshiftConnector::UrlDataFileBundle.new(query.data_file_urls)
      when 'failed'
        raise QueryError.new(query.error)
      end
    end
  end
end
