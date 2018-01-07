Given "I have an account" do
  UserRepository.new.clear
  @current_user = UserRepository.new.create(full_name: "Max Mustermann", email: "max@mustermann.de", password: "password", token: 'usertoken')
  header 'Authorization', "Basic #{Base64.encode64([@current_user.id, 'usertoken'].join(':')).chomp}"
end

When "a request is performed with valid values" do
  @contract_count = ContractRepository.new.count

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { contract: {
    vendor: 'Cucumber',
    starts_on: '2018-01-01T00:00:00Z',
    ends_on: '2019-01-01T00:00:00Z'
  } }
  post('/contracts', JSON.dump(json))
end

Then "a contract should be created" do
  expect(ContractRepository.new.count).to eq(@contract_count+1)
end

Then "a contract should not be created" do
  expect(ContractRepository.new.count).to eq @contract_count
end
