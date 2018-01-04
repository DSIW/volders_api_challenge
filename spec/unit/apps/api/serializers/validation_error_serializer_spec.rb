describe Api::Serializers::ValidationErrorSerializer do
  let(:errors) { {full_name: ['must be filled']} }

  describe "#new" do
    it 'accepts Hash' do
      expect(described_class.new(errors)).to be_a described_class
    end
  end

  describe "#to_json" do
    it 'returns correct JSON' do
      converted_hash = {
        "errors": {
          "full_name": [
            {"message": "Full Name must be filled"}
          ]
        }
      }
      expect(JSON).to receive(:dump).with(converted_hash).and_return('JSON')
      json = described_class.new(errors).to_json
      expect(json).to eq 'JSON'
    end
  end
end
