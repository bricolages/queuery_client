require 'queuery_client/data_file'
require 'forwardable'

module QueueryClient
  class S3DataFile < DataFile
    extend Forwardable

    def initialize(object)
      @object = object
    end

    def_delegators '@object', :url, :key, :presigned_url

    def open
      @object.get.body
    end
  end
end
