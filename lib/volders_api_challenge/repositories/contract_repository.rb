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
end
