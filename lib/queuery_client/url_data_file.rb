require 'net/http'
require 'stringio'
require 'redshift_csv_file'

module QueueryClient
  class UrlDataFile
    def initialize(url)
      @url = url
    end

    attr_reader :url

    def key
      @url.path
    end

    def data_object?
      /\.csv(?:\.|\z)/ =~ File.basename(key)
    end

    def gzipped_object?
      File.extname(key) == '.gz'
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

    def each_row(&block)
      f = open
      begin
        if gzipped_object?
          f = Zlib::GzipReader.new(f)
        end
        RedshiftCsvFile.new(f).each(&block)
      ensure
        f.close
      end
    end
  end
end
