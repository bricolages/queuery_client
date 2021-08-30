require 'json'

module QueueryClient
  class ManifestFile
    def manifest_object?
      /\.manifest(?:\.|\z)/ =~ File.basename(key)
    end

    def column_types
      f = open
      begin
        j = JSON.load(f)
        j['schema']['elements'].map{|x| x['type']['base']}
      ensure
        f.close
      end
    end

    def has_manifest?
      !manifest_file.nil?
    end
  end
end
