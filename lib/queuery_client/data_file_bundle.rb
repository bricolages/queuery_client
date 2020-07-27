module QueueryClient
  class DataFileBundle
    # abstract data_files :: [DataFile]

    def each_row(&block)
      return enum_for(:each_row) if !block_given?

      data_files.each do |file|
        if file.data_object?
          file.each_row do |row|
            yield row
          end
        end
      end

      self
    end

    alias each each_row
  end
end
