# This class represents an exception which will be converted to HTTP response
module Api::Errors
  class HttpError < StandardError
    def initialize(message)
      super(message)
    end

    def status
      400
    end

    def headers
      {}
    end

    def body
      JSON.dump({errors: [{message: message}]})
    end
  end
end
