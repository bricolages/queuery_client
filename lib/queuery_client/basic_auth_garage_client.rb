require 'garage_client'

module QueueryClient
  class BasicAuthGarageClient < GarageClient::Client
    # Override
    def apply_auth_middleware(faraday_builder)
      faraday_builder.use Faraday::Request::BasicAuthentication, login, password
    end

    def login
      options[:login]
    end

    def login=(login)
      options[:login] = login
    end

    def password
      options[:password]
    end

    def password=(password)
      options[:password] = password
    end
  end
end
