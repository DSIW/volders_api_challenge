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
    #   Serializer.new(user)
    #   Serializer.new(user, [:name])
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
    #   Serializer.new(user).to_json #=> `{"name":"Peter","age":21}`
    #
    #   Serializer.new(user, [:name]).to_json #=> `{"name":"Peter"}`
    def to_json
      filtered_attributes = @attributes.reduce({}) do |hash, attr|
        hash.merge!(attr => @obj.send(attr))
      end
      JSON.dump(filtered_attributes)
    end
  end
end
