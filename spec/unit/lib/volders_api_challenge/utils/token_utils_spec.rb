describe TokenUtils do
  describe ".generate" do
    it 'raises ArgumentError if identifier contains ":"' do
      expect { TokenUtils.generate("abc:def", 32) }.to raise_error(ArgumentError)
    end
    
    it 'raises ArgumentError if length is odd' do
      expect { TokenUtils.generate(1, 33) }.to raise_error(ArgumentError)
    end

    it 'generates base64 encoded string' do
      expect(Base64.decode64(TokenUtils.generate(1, 32))).to match /1:[a-z0-9]{32}/
    end
  end

  describe ".check" do
    let(:encoded_token) { Base64.encode64(['1', 'secret'].join(':')) }

    describe 'when secrets are equals' do
      it 'returns true' do
        correct = TokenUtils.check(encoded_token) do |user_id|
          'secret'
        end
        expect(correct).to be true
      end
    end

    describe 'when secrets are different' do
      it 'returns false' do
        correct = TokenUtils.check(encoded_token) do |user_id|
          'wrong_secret'
        end
        expect(correct).to be false
      end
    end

    describe 'when token does not contain secret' do
      let(:encoded_token) { Base64.encode64('1') }

      it 'returns false' do
        correct = TokenUtils.check(encoded_token) do |user_id|
          'wrong_secret'
        end
        expect(correct).to be false
      end
    end
  end
end
