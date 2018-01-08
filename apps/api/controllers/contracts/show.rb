# This controller gets information about one contract.
#
# This controller is protected by HTTP Basic Auth.
module Api::Controllers::Contracts
  class Show
    include Api::Action
    include Api::Controllers::Authentication

    # Creates a new instance of this controller.
    #
    # @param repository [Hanami::Repository] repository for the persistence
    #
    # @example
    #   Show.new()
    #   Show.new(ContractRepository.new)
    def initialize(repository = ContractRepository.new)
      @repository = repository
    end

    # Fetch one contract with specified id from database. The response contains the serialized
    # contract.
    #
    # @raise [NotFoundError] if your are not the owner of this contract
    #
    # @example
    #   Show.new.call({id: '1'})
    def call(params)
      contract = @repository.find_by_id_and_user_id(params[:id], current_user.id)

      raise Api::Errors::NotFoundError, 'Contract' unless contract

      self.body = Api::Serializers::ContractSerializer.new(contract).to_json
      self.status = 200
    end
  end
end
