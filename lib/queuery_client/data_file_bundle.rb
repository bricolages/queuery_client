require 'queuery_client/redshift_data_type'
require 'date'
require 'time'

module QueueryClient
  class DataFileBundle
    # abstract data_files :: [DataFile]
    # abstract manifest_file :: ManifestFile
    # abstract def has_manifest?

    def each_row(&block)
      return enum_for(:each_row) if !block_given?

      data_files.each do |file|
        if file.data_object?
          file.each_row do |row|
            if has_manifest?
              yield RedshiftDataType.type_cast(row, manifest_file)
            else
              yield row
            end
          end
        end
      end

      self
    end
    alias each each_row

  end
end
