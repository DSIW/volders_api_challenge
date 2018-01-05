describe ContractRepository do
  it 'extends from Hanami::Repository' do
    expect(described_class.new).to be_a Hanami::Repository
  end

  describe "#count" do
    it 'calls contracts.count' do
      allow_any_instance_of(described_class).to receive(:contracts).and_return(double("Contracts", count: 2))
      expect(described_class.new.count).to eq 2
    end
  end
end
