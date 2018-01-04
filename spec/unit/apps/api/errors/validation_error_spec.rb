describe Api::Errors::ValidationError do
  let(:error) { described_class.new(params) }
  let(:params) { {a: :b} }

  it 'extends from HttpError' do
    expect(described_class.new).to be_a Api::Errors::HttpError
  end

  describe "#new" do
    it 'accepts nothing' do
      expect(described_class.new).to be_a described_class
    end

    it 'accepts params' do
      expect(error).to be_a described_class
    end
  end

  describe "#status" do
    it 'returns 422' do
      expect(error.status).to eq 422
    end
  end

  describe "#message" do
    it 'returns "Invalid parameters"' do
      expect(error.message).to eq 'Invalid parameters'
    end
  end

  describe "#body" do
    it 'calls ValidationErrorSerializer#to_json' do
      serializer_double = instance_double(Api::Serializers::ValidationErrorSerializer, to_json: 'JSON')
      expect(Api::Serializers::ValidationErrorSerializer).to receive(:new).with(params).and_return(serializer_double)
      expect(error.body).to eq 'JSON'
    end
  end
end
