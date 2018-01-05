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

  # Finds first user by token
  #
  # @param token [String] token
  #
  # @example
  #   UserRepository.new.find_by_token('abc123...')
  def find_by_token(token)
    users.where(token: token).first
  end
end
