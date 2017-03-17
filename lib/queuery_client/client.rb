require 'garage_client'

module QueueryClient
  GarageClient.configure do |config|
    config.name = 'queuery-client'
  end

  class Client
    def initialize(endpoint)
      @endpoint = endpoint
    end

    def execute_query(select_stmt)
      garage_client.post("/v1/queries", q: select_stmt)
    end

    def get_query(id)
      garage_client.get("/v1/queries/#{id}")
    end

    def wait_for(id)
      loop do
        query = get_query(id)
        case query.status
        when 'success', 'failed'
          return query
        end
        sleep 1
      end
    end

    def query_and_wait(select_stmt)
      query = execute_query(select_stmt)
      wait_for(query.id)
    end

    def garage_client
      @garage_client ||= GarageClient::Client.new(
        endpoint: @endpoint,
        path_prefix: '/',
      )
    end
  end
end
