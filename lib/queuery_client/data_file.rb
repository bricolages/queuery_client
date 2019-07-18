require 'redshift_csv_file'
require 'zlib'

module QueueryClient
  class DataFile
    def data_object?
      /\.csv(?:\.|\z)/ =~ File.basename(key)
    end

    def gzipped_object?
      File.extname(key) == '.gz'
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
