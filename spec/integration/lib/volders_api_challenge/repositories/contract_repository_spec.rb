describe ContractRepository do
  let(:repo) { described_class.new }
  let!(:user) { UserRepository.new.create(full_name: 'Max Mustermann') }
  let!(:user_2) { UserRepository.new.create(full_name: 'Max Mustermann') }

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

  describe '#find_by_id_and_user_id' do
    let(:contract_1) { repo.create(id: 1, user_id: user.id) }
    let(:contract_2) { repo.create(id: 2, user_id: user_2.id) }

    describe 'with correct id and user_id' do
      it 'finds the contract' do
        expect(repo.find_by_id_and_user_id(contract_1.id, user.id)).to eq contract_1
      end
    end

    describe 'with correct id and non owning user_id' do
      it 'finds the contract' do
        expect(repo.find_by_id_and_user_id(contract_1.id, user_2.id)).to eq nil
      end
    end

    describe 'with wrong id and owning user_id' do
      it 'finds the contract' do
        expect(repo.find_by_id_and_user_id(99, user.id)).to eq nil
      end
    end
  end

  it 'deletes all contracts after deleting user' do
    repo.create(user_id: user.id)
    repo.create(user_id: user.id)

    expect(repo.count).to eq 2

    UserRepository.new.delete(user.id)

    expect(repo.count).to eq 0
  end
end
