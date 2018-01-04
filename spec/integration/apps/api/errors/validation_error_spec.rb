describe Api::Errors::ValidationError do
  describe "#body" do
    it 'returns the errors JSON' do
      body = described_class.new({email: ['is already taken']}).body
      expect(body).to eq '{"errors":{"email":[{"message":"Email is already taken"}]}}'
    end
  end
end
