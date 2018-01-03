# This controller persists user from POST requests
module Api::Controllers::Users
  class Create
    include Api::Action

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
    #   Create.new.call({user: {full_name: 'Max'}})
    def call(params)
      user = @repository.create(params[:user])

      self.body = Serializer.new(user, [:id, :full_name, :email]).to_json
      self.status = 201
    end
  end
end
