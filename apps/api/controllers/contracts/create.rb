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

    params do
      # FIXME: This should work without it, but unfortunately
      # Hanami::Validators needs to be configured this way.
      configure { config.messages_file = 'config/messages.yml' }

      required(:contract).schema(Api::Validators::ContractValidator)
    end

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
    # @raise [ValidationError] if parameters are not valid.
    #
    # @example
    #   Create.new.call({contract: {vendor: 'Vendor', starts_on: '2017-01-01T00:00:00Z', ends_on: '2019-01-01T00:00:00'}})
    def call(params)
      unless params.valid?
        raise Api::Errors::ValidationError.new(params.errors[:contract])
      end

      contract_params = Hash(params[:contract]).merge(user_id: current_user.id)
      contract = @repository.create(contract_params)

      self.body = Api::Serializers::ContractSerializer.new(contract).to_json
      self.status = 201
    end
  end
end
