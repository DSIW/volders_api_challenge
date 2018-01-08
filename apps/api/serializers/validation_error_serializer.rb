module Api::Serializers
  class ValidationErrorSerializer
    # Create instance of ErrorSerializer
    #
    # @param errors [Hash] hash containing errors from Hanami::Validator
    #
    # @example
    #   ErrorSerializer.new({full_name: ['must be filled']})
    def initialize(errors)
      @errors = errors
    end

    # Convert error hash to hash containing message which is readable by humans
    #
    # @example
    #   serializer = ErrorSerializer.new({full_name: ['must be filled']})
    #   serializer.to_json #=> '{"errors": {"full_name": [{"message": "Full Name must be filled"}]}}'
    def to_json
      JSON.dump({errors: serialized_errors})
    end

    private

    def serialized_errors
      return [] if @errors.nil?

      @errors.reduce({}) do |hash, (attr, error_messages)|
        human_attr = humanize(attr)
        messages = error_messages.map do |error_message|
          {message: generate_message(human_attr, error_message)}
        end
        hash.merge!({attr => messages})
      end
    end

    # Convert symbol to human readable string with capitalized words
    #
    # @example
    #   humanize(:full_name) #=> 'Full Name'
    def humanize(symbol)
      human_attr = symbol.to_s.split('_').map(&:capitalize).join(' ')
    end

    # Generate message
    def generate_message(human_attr, error_message)
      [human_attr, error_message].join(' ')
    end
  end
end
