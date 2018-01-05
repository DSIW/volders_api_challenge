module Api::Errors
  class PermissionDeniedError < HttpError
    def initialize(message = 'Unauthorized')
      super(message)
    end

    def status
      401
    end
  end
end
