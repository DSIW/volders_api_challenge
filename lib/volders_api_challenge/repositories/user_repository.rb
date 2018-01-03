class UserRepository < Hanami::Repository
  # Returns the number of persisted users
  # @return [Number] number
  #
  # @example
  #   UserRepository.new.count #=> 0
  #   UserRepository.new.create(full_name: 'Max')
  #   UserRepository.new.count #=> 1
  def count
    users.count
  end
end
