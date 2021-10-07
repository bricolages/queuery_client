require 'queuery_client/manifest_file'
require 'net/http'
require 'stringio'
require 'json'

module QueueryClient
  class UrlManifestFile < ManifestFile
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
