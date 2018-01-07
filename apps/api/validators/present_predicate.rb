module Api::Validators
  module PresentPredicate
    include Hanami::Validations::Predicates

    self.messages_path = 'config/messages.yml'

    # Use present? predicate to set custom message (works the same as filled?)
    predicate :present? do |current|
      !current.to_s.empty?
    end
  end
end
