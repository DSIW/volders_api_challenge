Given "I don't have an account" do
  UserRepository.new.clear
end

When /^perform a request with valid values$/ do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { user: {
    full_name: 'Max Mustermann',
    email: 'max@mustermann.de',
    password: 'password'
  } }
  post('/users', JSON.dump(json))
end

When /^perform a request with an empty (.+)$/ do |param|
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { user: {
    full_name: 'Max Mustermann',
    email: 'max@mustermann.de',
    password: 'password'
  } }
  json[:user][param.to_sym] = ''
  post('/users', JSON.dump(json))
end

Then "an account should be created" do
  expect(UserRepository.new.count).to eq 1
  expect(UserRepository.new.first.full_name).to eq 'Max Mustermann'
end

Then /^the status code should be (\d+)$/ do |code|
  expect(last_response.status).to eq code.to_i
end
