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
      filtered_attributes = @attributes.reduce({}) do |hash, attr|
        value = self.respond_to?(attr) ? send(attr) : @obj.send(attr)
        hash.merge!(attr => value)
      end
      JSON.dump(filtered_attributes)
    end
  end
end
