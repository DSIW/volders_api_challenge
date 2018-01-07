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

Then "a contract should not be created" do
  expect(ContractRepository.new.count).to eq @contract_count
end
