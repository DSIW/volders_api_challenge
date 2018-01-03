describe Serializer do
  let(:serializable_object) { double('User', name: 'Peter', age: 21, to_h: {name: 'Peter', age: 21}) }
  let(:serializer) { described_class.new(serializable_object) }
  let(:serializer_with_attrs) { described_class.new(serializable_object, [:name]) }

  describe "#new" do
    it 'accepts object' do
      expect(serializable_object).to receive(:to_h)
      expect(serializer).to be_a Serializer
    end

    it 'accepts object and attributes' do
      expect(serializer_with_attrs).to be_a Serializer
    end
  end

  describe "#to_json" do
    it 'renders attributes to JSON' do
      expect(JSON).to receive(:dump).with({name: 'Peter'}) do
        '{"name":"Peter"}'
      end
      expect(serializer_with_attrs.to_json).to eq '{"name":"Peter"}'
    end
  end
end
