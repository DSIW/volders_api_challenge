describe Api::Errors::NotFoundError do
  let(:error) { described_class.new(name) }
  let(:name) { 'Resource' }

  it 'extends from HttpError' do
    expect(described_class.new).to be_a Api::Errors::HttpError
  end

  describe "#new" do
    it 'accepts nothing' do
      expect(described_class.new).to be_a described_class
    end

    it 'accepts resource_name' do
      expect(error).to be_a described_class
    end
  end

  describe "#status" do
    it 'returns 404' do
      expect(error.status).to eq 404
    end
  end

  describe "#message" do
    describe 'with resource "Name"' do
      it 'returns "Name not found"' do
        expect(described_class.new('Name').message).to eq 'Name not found'
      end
    end

    describe 'without resource' do
      it 'returns "Resource not found"' do
        expect(described_class.new.message).to eq 'Resource not found'
      end
    end
  end
end
