describe ContractRepository do
  let(:repo) { described_class.new }

  before do
    repo.clear
  end

  describe "#count" do
    it 'returns the number of persisted objects' do
      expect(repo.count).to eq 0
      repo.create(vendor: 'Vendor name')
      expect(repo.count).to eq 1
    end
  end
end
