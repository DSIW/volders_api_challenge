describe Contract do
  let(:contract) { described_class.new(vendor: 'Vendor name', starts_on: start_time, ends_on: end_time) }
  let(:start_time) { Time.new(2018, 1, 1) }
  let(:end_time) { Time.new(2019, 1, 1) }

  it 'extends from Hanami::Entity' do
    expect(described_class.new).to be_a Hanami::Entity
  end

  describe "#vendor" do
    it 'returns the vendor' do
      expect(contract.vendor).to eq 'Vendor name'
    end
  end

  describe "#starts_on" do
    it 'returns the start time' do
      expect(contract.starts_on).to eq start_time
    end
  end

  describe "#ends_on" do
    it 'returns the end time' do
      expect(contract.ends_on).to eq end_time
    end
  end
end
