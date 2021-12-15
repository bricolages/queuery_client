module QueueryClient
  class Client
    def initialize(options = {})
      @options = options
    end

    def execute_query(select_stmt, values, query_options)
      garage_client.post("/v1/queries", q: select_stmt, values: values, enable_metadata: query_options[:enable_cast])
    end
    alias start_query execute_query

    def get_query(id, query_options)
      query_option_fields = build_query_option_fields(query_options)
      garage_client.get("/v1/queries/#{id}", fields: '__default__,s3_prefix' + query_option_fields)
    end

    MAX_POLLING_INTERVAL = 30

    def wait_for(id, query_options)
      n = 0
      loop do
        query = get_query(id, query_options)
        case query.status
        when 'success', 'failed'
          return query
        end
        n += 1
        sleep [3 * n, MAX_POLLING_INTERVAL].min
      end
    end

    def query_and_wait(select_stmt, values, query_options)
      query = execute_query(select_stmt, values, query_options)
      wait_for(query.id, query_options)
    end

    def query(select_stmt, values, **query_options)
      query = query_and_wait(select_stmt, values, query_options)
      manifest_file_url = query.manifest_file_url if query_options[:enable_cast]
      case query.status
      when 'success'
        UrlDataFileBundle.new(
          query.data_file_urls,
          manifest_file_url,
          s3_prefix: query.s3_prefix,
        )
      when 'failed'
        raise QueryError.new(query.error)
      end
    end

    # poll_result returns the results only if the query has already successed.
    def poll_result(id)
      query = get_query(id)
      get_query_result(query)
    end

    def garage_client
      @garage_client ||= BasicAuthGarageClient.new(
        endpoint: options.endpoint,
        path_prefix: '/',
        login: options.token,
        password: options.token_secret
      ).tap do |client|
        client.headers['Host'] = options.host_header if options.host_header
      end
    end

    def options
      default_options.merge(@options)
    end

    def default_options
      QueueryClient.configuration
    end

    private

    def get_query_result(query)
      case query.status
      when 'pending', 'running'
        nil
      when 'success'
        UrlDataFileBundle.new(
          query.data_file_urls,
          nil,
          s3_prefix: query.s3_prefix,
        )
      when 'failure'
        raise QueryError.new(query.error)
      end
    end

    def build_query_option_fields(query_options)
      enable_query_options = query_options.select{ |name, v| name if v }.keys
      return '' if enable_query_options.empty?
      query_option_fields = enable_query_options.map{ |option_name| convert_field_name(option_name) }
      ',' + query_option_fields.join(',')
    end

    def convert_field_name(option_name)
      case option_name
        when :enable_cast
          'manifest_file_url'
        # add another option here if you need
      end
    end
  end
end
