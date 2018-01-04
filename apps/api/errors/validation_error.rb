module Api::Errors
  class ValidationError < HttpError
    def initialize(params = {})
      super("Invalid parameters")
      @params = params
    end

    def status
      422
    end

    def body
      Api::Serializers::ValidationErrorSerializer.new(@params).to_json
    end
  end
end
