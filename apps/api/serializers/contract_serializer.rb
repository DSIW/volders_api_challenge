require_relative 'model_serializer'

module Api::Serializers
  class ContractSerializer < ModelSerializer
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%zZ'

    SERIALIZABLE_ATTRIBUTES = [
      :id,
      :vendor,
      :starts_on,
      :ends_on,
      :user_id
    ]

    def initialize(contract, attributes = SERIALIZABLE_ATTRIBUTES)
      super(contract, attributes)
    end

    def starts_on
      @obj.starts_on && @obj.starts_on.strftime(TIME_FORMAT)
    end

    def ends_on
      @obj.ends_on && @obj.ends_on.strftime(TIME_FORMAT)
    end
  end
end
