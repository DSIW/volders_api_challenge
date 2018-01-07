require_relative 'present_predicate'

module Api::Validators
  class ContractValidator
    include Hanami::Validations

    predicates Api::Validators::PresentPredicate

    validations do
      required(:vendor)    { type?(String) & present? }
      required(:starts_on) { type?(String) & present? }
      required(:ends_on)   { type?(String) & present? }

      rule(ends_on: [:starts_on, :ends_on]) do |starts_on, ends_on|
        ends_on.gt?(starts_on)
      end
    end
  end
end
