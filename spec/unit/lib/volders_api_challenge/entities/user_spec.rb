describe User do
  it 'extends from Hanami::Entity' do
    expect(User.new).to be_a Hanami::Entity
  end
end
