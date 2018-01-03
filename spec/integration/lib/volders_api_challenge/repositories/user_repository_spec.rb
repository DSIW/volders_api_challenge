RSpec.describe UserRepository do
  describe "#count" do
    it 'returns the number of persisted objects' do
      UserRepository.new.clear
      expect(UserRepository.new.count).to eq 0
      UserRepository.new.create(full_name: 'Max', email: 'max@mustermann.de', password: 'password')
      expect(UserRepository.new.count).to eq 1
    end
  end
end
