describe Api::Serializers::ValidationErrorSerializer do
  let(:errors) { {full_name: ['must be filled']} }
  let(:serializer) { described_class.new(errors) }

  describe "#new" do
    it 'accepts Hash' do
      expect(serializer).to be_a described_class
    end
  end

  describe "#to_json" do
    describe 'when errors = nil' do
      let(:errors) { nil }

      it 'JSON receives {errors: []}' do
        expect(JSON).to receive(:dump).with({errors: []})
        serializer.to_json
      end
    end

    describe 'with error hash' do
      it 'returns correct JSON' do
        converted_hash = {
          "errors": {
            "full_name": [
              {"message": "Full Name must be filled"}
            ]
          }
        }
        expect(JSON).to receive(:dump).with(converted_hash).and_return('JSON')
        json = serializer.to_json
        expect(json).to eq 'JSON'
      end
    end
  end
end
