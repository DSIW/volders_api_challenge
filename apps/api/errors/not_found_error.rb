module Api::Errors
  class NotFoundError < HttpError
    def initialize(resource_name = 'Resource')
      super("#{resource_name} not found")
    end

    def status
      404
    end
  end
end
