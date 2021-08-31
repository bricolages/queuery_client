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
              yield type_cast(row)
            else
              yield row
            end
          end
        end
      end

      self
    end
    alias each each_row

    def type_cast(row)
      row.zip(manifest_file.column_types).map do |value, type|
        next nil if (value == '' and type != 'character varing') # null becomes '' on unload

        case type
        when 'smallint', 'integer', 'bigint'
          value.to_i
        when 'numeric', 'double precision'
          value.to_f
        when 'character', 'character varing'
          value
        when 'timestamp without time zone', 'timestamp with time zone'
          Time.parse(value)
        when 'date'
          Date.parse(value)
        when 'boolean'
          value == 'true' ? true : false
        else
          value
        end
      end
    end
  end
end
