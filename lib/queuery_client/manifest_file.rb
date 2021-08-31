require 'json'

module QueueryClient
  class ManifestFile # abstract class
    def manifest_object?
      /\.manifest(?:\.|\z)/ =~ File.basename(key)
    end

    def column_types
      @column_types ||=
        begin
          f = open
          j = JSON.load(f)
          j['schema']['elements'].map{|x| x['type']['base']}
        ensure
          f.close
        end
    end
  end
end
