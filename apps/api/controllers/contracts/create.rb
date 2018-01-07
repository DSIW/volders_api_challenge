# This controller persists contract from POST requests.
#
# This controller is protected by HTTP Basic Auth.
#
# It checks if all parameters are set and valid, otherwise it returns an
# error.
module Api::Controllers::Contracts
  class Create
    include Api::Action
    include Api::Controllers::Authentication

    # Creates a new instance of this controller.
    #
    # @param repository [Hanami::Repository] repository for the persistence
    #
    # @example
    #   Create.new()
    #   Create.new(ContractRepository.new)
    def initialize(repository = ContractRepository.new)
      @repository = repository
    end

    # Creates contract with parameters in HTTP body by calling `POST /contracts`. The response contains the serialized
    # contract.
    #
    # It assigns the current authenticated user to the contract.
    #
    # @raise [PermissionDeniedError] if authentication failed
    #
    # @example
    #   Create.new.call({})
    def call(params)
    end
  end
end
