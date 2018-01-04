# This controller persists user from POST requests.
#
# It checks if all parameters are set and valid, otherwise it returns an
# error.
module Api::Controllers::Users
  class Create
    include Api::Action

    params do
      # FIXME: This should work without it, but unfortunately
      # Hanami::Validators needs to be configured this way.
      configure { config.messages_file = 'config/messages.yml' }

      required(:user).schema(Api::Validators::UserValidator)
    end

    # Creates a new instance of this controller.
    #
    # @param repository [Hanami::Repository] repository for the persistence
    #
    # @example
    #   Create.new()
    #   Create.new(UserRepository.new)
    def initialize(repository = UserRepository.new)
      @repository = repository
    end

    # Creates user with parameters in HTTP body by calling `POST /users`. The response contains the serialized user.
    #
    # It raises an `ValidationError` if parameters are not valid or unique contraint is violated. The middleware
    # `HttpErrorHandler` generates the corresponding HTTP response.
    #
    # @example
    #   Create.new.call({user: {full_name: 'Max', email: 'max@mustermann.de', password: 'password'}})
    def call(params)
      unless params.valid?
        raise Api::Errors::ValidationError.new(params.errors[:user])
      end

      begin
        params[:user].merge!(token: SecureRandom.hex(Api::Constants::TOKEN_LENGTH / 2))
        user = @repository.create(params[:user])
      rescue Hanami::Model::UniqueConstraintViolationError => e
        add_error(params, :user, :email, 'is already taken')
        raise Api::Errors::ValidationError.new(params.errors[:user])
      end

      self.body = Api::Serializers::ModelSerializer.new(user, [:id, :full_name, :email]).to_json
      self.status = 201
    end

    private

    def add_error(params, model, attribute, message)
      params.errors[model] ||= {}
      params.errors[model][attribute] ||= []
      params.errors[model][attribute] << message
    end
  end
end
