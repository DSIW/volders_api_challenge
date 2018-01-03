describe Serializer do
  let(:serializable_object) { User.new(full_name: "Max", password: "password") }

  describe "#to_json" do
    describe 'when no arguments are specified' do
      it 'renders all attributes' do
        serializer = described_class.new(serializable_object)
        expect(serializer.to_json).to eq '{"full_name":"Max","password":"password"}'
      end
    end

    describe 'when arguments are specified' do
      it 'renders specified attributes' do
        serializer_with_attrs = described_class.new(serializable_object, [:full_name])
        expect(serializer_with_attrs.to_json).to eq '{"full_name":"Max"}'
      end
    end
  end
end
