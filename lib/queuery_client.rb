require "queuery_client/version"
require "queuery_client/configuration"
require "queuery_client/basic_auth_garage_client"
require "queuery_client/query_error"
require "queuery_client/client"
require "queuery_client/url_data_file_bundle"
require "queuery_client/s3_data_file_bundle"

module QueueryClient
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure(&block)
      configuration.instance_eval(&block)
    end

    def query(select_stmt, values = [], enable_cast: false)
      Client.new.query(select_stmt, values, enable_cast: enable_cast)
    end
  end
end
