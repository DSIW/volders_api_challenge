describe User do
  let(:user) { described_class.new(full_name: 'Max Mustermann', email: 'max@mustermann.de', password: 'password') }

  it 'extends from Hanami::Entity' do
    expect(described_class.new).to be_a Hanami::Entity
  end

  describe "#full_name" do
    it 'returns the full name' do
      expect(user.full_name).to eq 'Max Mustermann'
    end
  end

  describe "#email" do
    it 'returns the email' do
      expect(user.email).to eq 'max@mustermann.de'
    end
  end

  describe "#password" do
    it 'returns the password' do
      expect(user.password).to eq 'password'
    end
  end
end
