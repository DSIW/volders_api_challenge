RSpec.describe UserRepository do
  describe "#count" do
    it 'calls users.count' do
      allow_any_instance_of(UserRepository).to receive(:users).and_return(double("Users", count: 2))
      expect(UserRepository.new.count).to eq 2
    end
  end

  describe "#find_by_token" do
    it 'uses the right where clause and sets limit to 1' do
      user_relation = double("UserRelation")
      user = instance_double(User)

      allow_any_instance_of(UserRepository).to receive(:users).and_return(user_relation)
      allow(user_relation).to receive(:where).with(token: 'token').and_return([user])
      expect(UserRepository.new.find_by_token('token')).to be user
    end
  end
end
