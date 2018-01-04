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

    # Creates user with parameters in HTTP body by calling `POST /users`.
    #
    # @example
    #   Create.new.call({user: {full_name: 'Max', email: 'max@mustermann.de', password: 'password'}})
    def call(params)
      if params.valid?
        user = @repository.create(params[:user])

        self.body = Api::Serializers::ModelSerializer.new(user, [:id, :full_name, :email]).to_json
        self.status = 201
      else
        self.body = Api::Serializers::ValidationErrorSerializer.new(params.errors[:user]).to_json
        self.status = 422
      end
    end
  end
end
