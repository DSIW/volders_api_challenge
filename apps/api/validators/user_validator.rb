module Api::Validators
  class UserValidator
    include Hanami::Validations

    predicates Api::Validators::PresentPredicate

    validations do
      required(:full_name) { type?(String) & present? }
      required(:email)     { type?(String) & present? }
      required(:password)  { type?(String) & present? }
    end
  end
end
