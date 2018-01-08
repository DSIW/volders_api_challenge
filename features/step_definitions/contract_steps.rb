Given "I have an account" do
  UserRepository.new.clear
  @current_user = UserRepository.new.create(full_name: "Max Mustermann", email: "max@mustermann.de", password: "password", token: 'usertoken')
  header 'Authorization', "Basic #{Base64.encode64([@current_user.id, 'usertoken'].join(':')).chomp}"
end

When "a contract request is performed with valid values" do
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

When /^a contract request is performed with an empty (.+)$/ do |param|
  @contract_count = ContractRepository.new.count

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { contract: {
    vendor: 'Cucumber',
    starts_on: '2018-01-01T00:00:00Z',
    ends_on: '2019-01-01T00:00:00Z'
  } }
  json[:contract][param.to_sym] = ''
  post('/contracts', JSON.dump(json))
end

When "a contract request is performed with an ends_on < starts_on" do
  @contract_count = ContractRepository.new.count

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { contract: {
    vendor: 'Cucumber',
    starts_on: '2020-01-01T00:00:00Z',
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

When /^a request is performed to a contract that belongs to me$/ do
  @contract = ContractRepository.new.create(vendor: 'Vodafone', user_id: @current_user.id)

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  get("/contracts/#{@contract.id}")
end

Then /^I should see all the contract available fields$/ do
  contract = JSON.parse(last_response.body)
  expect(contract.keys).to match ['id', 'vendor', 'starts_on', 'ends_on', 'user_id']
  expect(contract['id']).to eq @contract.id
  expect(contract['user_id']).to eq @current_user.id
end

When /^a request is performed to a contract that does not belong to me$/ do
  other_user = UserRepository.new.create(full_name: 'Other user')
  contract = ContractRepository.new.create(vendor: 'Vodafone', user_id: other_user.id)

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  get("/contracts/#{contract.id}")
end

When /^a delete request is performed to a contract that belongs to me$/ do
  contract = ContractRepository.new.create(vendor: 'Vodafone', user_id: @current_user.id)

  @contract_count = ContractRepository.new.count

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  delete("/contracts/#{contract.id}")
end

When /^a delete request is performed to a contract that does not belong to me$/ do
  other_user = UserRepository.new.create(full_name: 'User')
  contract = ContractRepository.new.create(vendor: 'Vodafone', user_id: other_user.id)

  @contract_count = ContractRepository.new.count

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  delete("/contracts/#{contract.id}")
end

Then /^I should see "([^"]*)" error to prevent information leaking$/ do |error|
  expect(last_response.body).to include "Contract not found"
end

Then /^the contract should be deleted$/ do
  expect(ContractRepository.new.count).to eq(@contract_count-1)
end

Then /^the contract should not be deleted$/ do
  expect(ContractRepository.new.count).to eq @contract_count
end
