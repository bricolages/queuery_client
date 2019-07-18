require 'redshift_csv_file'
require 'zlib'
require 'forwardable'
require 'logger'

module QueueryClient
  class S3DataFile
    extend Forwardable

    def initialize(object)
      @object = object
    end

    def_delegators '@object', :url, :key, :presigned_url

    def data_object?
      /\.csv(?:\.|\z)/ =~ File.basename(key)
    end

    def gzipped_object?
      File.extname(key) == '.gz'
    end

    def open
      @object.get.body
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
