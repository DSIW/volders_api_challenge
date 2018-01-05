RSpec.describe UserRepository do
  let(:repo) { UserRepository.new }

  before do
    repo.clear
  end

  describe "#count" do
    it 'returns the number of persisted objects' do
      expect(repo.count).to eq 0
      repo.create(full_name: 'Max', email: 'max@mustermann.de', password: 'password')
      expect(repo.count).to eq 1
    end
  end

  describe "#find_by_token" do
    describe "when user with token exists" do
      it 'returns the first user by token' do
        repo.create(full_name: 'Max', email: 'max@mustermann.de', password: 'password', token: 'token')
        expect(repo.count).to eq 1
        user = repo.find_by_token('token')
        expect(user.token).to eq 'token'
      end
    end

    describe "when user exists" do
      it 'returns the first user by token' do
        user = repo.find_by_token('nonexisting')
        expect(user).to be_nil
      end
    end
  end
end
