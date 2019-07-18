require 'queuery_client/data_file'
require 'net/http'
require 'stringio'

module QueueryClient
  class UrlDataFile < DataFile
    def initialize(url)
      @url = url
    end

    attr_reader :url

    def key
      @url.path
    end

    def open
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = (@url.scheme.downcase == 'https')
      content = http.start {
        res = http.get(@url.request_uri)
        res.body
      }
      StringIO.new(content)
    end
  end
end
