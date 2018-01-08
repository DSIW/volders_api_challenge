# JSON Serializer of objects
module Api::Serializers
  class ModelSerializer
    # Getters for `obj` and `attributes`
    attr_reader :obj, :attributes

    # Creates new serializer instance
    #
    # @param obj [Object] serializable object
    # @param attributes [Array,nil] Optional attributes which are included in JSON representation
    #
    # @example
    #   User = Struct.new(:name)
    #   user = User.new(name: "Peter")
    #
    #   ModelSerializer.new(user)
    #   ModelSerializer.new(user, [:name])
    def initialize(obj, attributes = nil)
      @obj = obj
      @attributes = attributes || obj.to_h.keys
    end

    # Returns serialized JSON of `obj`
    #
    # @return [String] JSON representation of obj
    #
    # @example
    #   ModelSerializer.new(nil).to_json #=> `{}`
    #
    # @example
    #   User = Struct.new(:name, :age)
    #   user = User.new(name: "Peter", age: 21)
    #
    #   ModelSerializer.new(user).to_json #=> `{"name":"Peter","age":21}`
    #
    #   ModelSerializer.new(user, [:name]).to_json #=> `{"name":"Peter"}`
    #
    #   class UserSerializer < ModelSerializer
    #     def type
    #       "users"
    #     end
    #   end
    #   UserSerializer.new(user, [:name, :type]).to_json #=> `{"name":"Peter", "type": "users"}`
    def to_json
      JSON.dump(filtered_attributes)
    end

    private

    def filtered_attributes
      return {} if @obj.nil?

      @attributes.reduce({}) do |hash, attr|
        if respond_to?(attr)
          value = send(attr)
        elsif @obj.respond_to?(attr)
          value = @obj.send(attr)
        end
        hash.merge!(attr => value)
      end
    end
  end
end
