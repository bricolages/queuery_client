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
      return enum_for(:each_row) if !block_given?

      f = open
      begin
        if gzipped_object?
          f = Zlib::GzipReader.new(f)
        end
        RedshiftCsvFile.new(f).each do |row|
          yield row
        end
      ensure
        f.close
      end

      self
    end
  end
end
