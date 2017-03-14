require 'garage_client'

module QueueryClient
  GarageClient.configure do |config|
    config.name = 'queuery-client'
  end

  class Client
    def initialize(endpoint)
      @endpoint = endpoint
    end

    def query(select_stmt)
      result = garage_client.post("/queries", q: select_stmt)
      result.response.body
    end

    def status(job_id)
      result = garage_client.get("/queries/#{job_id}")
      result.response.body
    end

    def wait_for(job_id)
      loop do
        res = status(job_id)
        case res['status']
        when 'success', 'failed'
          return res
        end
        sleep 1
      end
    end

    def query_and_wait(select_stmt)
      res = query(select_stmt)
      wait_for(res['job_id'])
    end

    def garage_client
      @garage_client ||= GarageClient::Client.new(
        endpoint: @endpoint,
        path_prefix: '/',
      )
    end
  end
end
