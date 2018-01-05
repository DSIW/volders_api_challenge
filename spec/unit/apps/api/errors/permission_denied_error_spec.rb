describe Api::Errors::PermissionDeniedError do
  let(:error) { described_class.new('Unauthorized') }

  it 'extends from HttpError' do
    expect(described_class.new).to be_a Api::Errors::HttpError
  end

  describe "#new" do
    it 'accepts nothing' do
      expect(described_class.new).to be_a described_class
    end

    it 'accepts message' do
      expect(error).to be_a described_class
    end
  end

  describe "#status" do
    it 'returns 401' do
      expect(error.status).to eq 401
    end
  end

  describe "#message" do
    it 'returns "Unauthorized"' do
      expect(error.message).to eq 'Unauthorized'
    end
  end
end
