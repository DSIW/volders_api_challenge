describe Api::Serializers::ValidationErrorSerializer do
  let(:errors) { {full_name: ['must be filled']} }

  describe "#to_json" do
    it 'returns correct JSON' do
      converted_hash = {
        "errors": {
          "full_name": [
            {"message": "Full Name must be filled"}
          ]
        }
      }
      json = described_class.new(errors).to_json
      expect(json).to eq '{"errors":{"full_name":[{"message":"Full Name must be filled"}]}}'
    end
  end
end
