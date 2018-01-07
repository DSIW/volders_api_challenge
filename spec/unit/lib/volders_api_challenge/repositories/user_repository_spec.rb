RSpec.describe UserRepository do
  describe "#count" do
    it 'calls users.count' do
      allow_any_instance_of(UserRepository).to receive(:users).and_return(double("Users", count: 2))
      expect(UserRepository.new.count).to eq 2
    end
  end
end
