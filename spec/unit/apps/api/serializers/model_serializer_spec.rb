describe Api::Serializers::ModelSerializer do
  class CustomSerializer < described_class
    def name
      'Name'
    end
  end

  let(:serializable_object) { double('User', name: 'Peter', age: 21, to_h: {name: 'Peter', age: 21}) }
  let(:serializer) { described_class.new(serializable_object) }
  let(:serializer_with_attrs) { described_class.new(serializable_object, [:name]) }

  describe "#new" do
    it 'accepts object' do
      expect(serializable_object).to receive(:to_h)
      expect(serializer).to be_a described_class
    end

    it 'accepts object and attributes' do
      expect(serializer_with_attrs).to be_a described_class
    end
  end

  describe "#to_json" do
    it 'renders attributes to JSON' do
      expect(JSON).to receive(:dump).with({name: 'Peter'}) { 'Name' }
      expect(serializer_with_attrs.to_json).to eq 'Name'
    end

    it 'uses serialized attribute if specified' do
      serializer = CustomSerializer.new(serializable_object, [:name])
      expect(JSON).to receive(:dump).with({name: 'Name'}) { 'JSON' }
      expect(serializer.to_json).to eq 'JSON'
    end
  end
end
