# This controller destroys one contract.
#
# This controller is protected by HTTP Basic Auth.
module Api::Controllers::Contracts
  class Destroy
    include Api::Action
    include Api::Controllers::Authentication

    # Creates a new instance of this controller.
    #
    # @param repository [Hanami::Repository] repository for the persistence
    #
    # @example
    #   Destroy.new()
    #   Destroy.new(ContractRepository.new)
    def initialize(repository = ContractRepository.new)
      @repository = repository
    end

    # Destroys one contract with specified id. The response contains the serialized
    # contract.
    #
    # @raise [NotFoundError] if your are not the owner of this contract
    #
    # @example
    #   Destroy.new.call({id: '1'})
    def call(params)
      contract = @repository.find_by_id_and_user_id(params[:id], current_user.id)
      raise Api::Errors::NotFoundError, 'Contract' unless contract
      @repository.delete(contract.id)

      self.body = Api::Serializers::ContractSerializer.new(contract).to_json
      self.status = 200
    end
  end
end
