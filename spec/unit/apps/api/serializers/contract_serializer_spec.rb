describe Api::Serializers::ContractSerializer do
  let(:serializer) { described_class.new(contract) }
  let(:contract) { double(Contract, id: 1, vendor: 'Vodafone', starts_on: time, ends_on: time, user_id: 1) }
  let(:time) { Time.new(2018, 1, 1, 0, 0, 0) }

  describe "#starts_on" do
    it 'returns time in ISO8601 format' do
      expect(serializer.starts_on).to eq '2018-01-01T00:00:00+0100Z'
    end
  end

  describe "#ends_on" do
    it 'returns time in ISO8601 format' do
      expect(serializer.ends_on).to eq '2018-01-01T00:00:00+0100Z'
    end
  end

  describe "#to_json" do
    it 'call JSON.dump with the right parameters' do
      expect(JSON).to receive(:dump).with({
        id: 1,
        vendor: 'Vodafone',
        starts_on: '2018-01-01T00:00:00+0100Z',
        ends_on: '2018-01-01T00:00:00+0100Z',
        user_id: 1
      }).and_return('JSON')
      expect(serializer.to_json).to eq 'JSON'
    end
  end
end
