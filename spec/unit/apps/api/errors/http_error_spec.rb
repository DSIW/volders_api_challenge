describe Api::Errors::HttpError do
  let(:http_error) { described_class.new('message') }

  it 'extends from StandardError' do
    expect(http_error).to be_a StandardError
  end

  describe "#new" do
    it 'accepts message' do
      expect(http_error).to be_a described_class
    end
  end

  describe "#status" do
    it 'returns 400' do
      expect(http_error.status).to eq 400
    end
  end

  describe "#headers" do
    it 'returns empty Hash' do
      expect(http_error.headers).to eq({})
    end
  end

  describe "#body" do
    it 'returns error JSON containing message' do
      expect(JSON). to receive(:dump).with({errors: [{message: 'message'}]}).and_return('JSON')
      expect(http_error.body).to eq 'JSON'
    end
  end
end
