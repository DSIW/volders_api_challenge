module Api::Validators
  module PresentPredicate
    include Hanami::Validations::Predicates

    self.messages_path = 'config/messages.yml'

    # Use present? predicate to set custom message (works the same as filled?)
    predicate :present? do |current|
      !current.to_s.empty?
    end
  end

  class UserValidator
    include Hanami::Validations

    predicates PresentPredicate

    validations do
      required(:full_name) { type?(String) & present? }
      required(:email)     { type?(String) & present? }
      required(:password)  { type?(String) & present? }
    end
  end
end
