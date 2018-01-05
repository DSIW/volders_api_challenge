describe Api::Errors::PermissionDeniedError do
  describe "#body" do
    it 'returns the errors JSON' do
      body = described_class.new.body
      expect(body).to eq '{"errors":[{"message":"Unauthorized"}]}'
    end
  end
end
