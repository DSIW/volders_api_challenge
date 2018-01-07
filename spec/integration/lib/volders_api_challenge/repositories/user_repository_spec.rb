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
end
