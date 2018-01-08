class ContractRepository < Hanami::Repository
  # Returns the number of persisted contracts
  # @return [Number] number
  #
  # @example
  #   ContractRepository.new.count #=> 0
  #   ContractRepository.new.create(...)
  #   ContractRepository.new.count #=> 1
  def count
    contracts.count
  end

  # Returns the contract by id and user_id
  #
  # @param id [Number] id of contract
  # @param user_id [Number] id of user who owns contract
  #
  # @return [Contract] found contract
  def find_by_id_and_user_id(id, user_id)
    contracts.where(id: id, user_id: user_id).one
  end
end
