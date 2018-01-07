describe Token do
  let(:token) { described_class.new(encoded_token) }
  let(:encoded_token) { Base64.encode64(['1', 'secret'].join(':')) }

  describe ".new" do
    it 'accepts one String' do
      expect(described_class.new('a')).to be_a described_class
    end
  end

  describe ".generate" do
    it 'raises ArgumentError if identifier contains ":"' do
      expect { described_class.generate("abc:def", 32) }.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError if length is odd' do
      expect { described_class.generate(1, 33) }.to raise_error(ArgumentError)
    end

    it 'generates base64 encoded string' do
      expect(Base64.decode64(described_class.generate(1, 32).base64_encoded)).to match /1:[a-z0-9]{32}/
    end
  end

  describe "#identifier" do
    it 'returns identifier' do
      expect(token.identifier).to eq '1'
    end
  end

  describe "#check" do
    describe 'when secrets are equals' do
      it 'returns true' do
        expect(token.check('secret')).to be true
      end
    end

    describe 'when secrets are different' do
      it 'returns false' do
        expect(token.check('wrong_secret')).to be false
      end
    end

    describe 'when token does not contain secret' do
      let(:encoded_token) { Base64.encode64('1') }

      it 'returns false' do
        expect(token.check('wrong_secret')).to be false
      end
    end
  end
end
