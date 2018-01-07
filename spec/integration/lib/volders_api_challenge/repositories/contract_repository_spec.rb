describe ContractRepository do
  let(:repo) { described_class.new }
  let!(:user) { UserRepository.new.create(full_name: 'Max Mustermann') }

  before do
    repo.clear
  end

  describe "#count" do
    it 'returns the number of persisted objects' do
      expect(repo.count).to eq 0
      repo.create(vendor: 'Vendor name', user_id: user.id)
      expect(repo.count).to eq 1
    end
  end

  it 'deletes all contracts after deleting user' do
    ContractRepository.new.create(user_id: user.id)
    ContractRepository.new.create(user_id: user.id)

    expect(ContractRepository.new.count).to eq 2

    UserRepository.new.delete(user.id)

    expect(ContractRepository.new.count).to eq 0
  end
end
