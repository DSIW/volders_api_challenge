describe Api::Serializers::ContractSerializer do
  let(:contract) { double(Contract, id: 1, vendor: 'Vodafone', starts_on: time, ends_on: time, user_id: 1) }
  let(:time) { Time.new(2018, 1, 1, 0, 0, 0) }

  describe '#to_json' do
    it 'returns serialized contract' do
      json = described_class.new(contract).to_json
      expect(json).to eq '{"id":1,"vendor":"Vodafone","starts_on":"2018-01-01T00:00:00+0100Z","ends_on":"2018-01-01T00:00:00+0100Z","user_id":1}'
    end
  end
end
