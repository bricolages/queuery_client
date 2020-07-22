module QueueryClient
  class Client
    def initialize(options = {})
      @options = options
    end

    def execute_query(select_stmt, values)
      garage_client.post("/v1/queries", q: select_stmt, values: values)
    end

    def get_query(id)
      garage_client.get("/v1/queries/#{id}", fields: '__default__,s3_prefix')
    end

    def wait_for(id)
      loop do
        query = get_query(id)
        case query.status
        when 'success', 'failed'
          return query
        end
        sleep 3
      end
    end

    def query_and_wait(select_stmt, values)
      query = execute_query(select_stmt, values)
      wait_for(query.id)
    end

    def query(select_stmt, values)
      query = query_and_wait(select_stmt, values)
      case query.status
      when 'success'
        UrlDataFileBundle.new(
          query.data_file_urls,
          s3_prefix: query.s3_prefix,
        )
      when 'failed'
        raise QueryError.new(query.error)
      end
    end

    # poll returns the results only if the query has already successed.
    def poll_results(id)
      get_query_results(id)
    end

    def garage_client
      @garage_client ||= BasicAuthGarageClient.new(
        endpoint: options.endpoint,
        path_prefix: '/',
        login: options.token,
        password: options.token_secret
      )
    end

    def options
      default_options.merge(@options)
    end

    def default_options
      QueueryClient.configuration
    end

    private

    def get_query_results(id)
      query = get_query(id)

      case query.status
      when 'pending', 'running'
        nil
      when 'success'
        UrlDataFileBundle.new(
          query.data_file_urls,
          s3_prefix: query.s3_prefix,
        )
      when 'failure'
        raise QueryError.new(query.error)
      end
    end
  end
end
