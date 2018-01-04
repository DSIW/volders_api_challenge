Given "I don't have an account" do
  UserRepository.new.clear
end

When /^perform a request with valid values$/ do
  @users_count = UserRepository.new.count

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { user: {
    full_name: 'Max Mustermann',
    email: 'max@mustermann.de',
    password: 'password'
  } }
  post('/users', JSON.dump(json))
end

When /^a request is performed with an empty (.+)$/ do |param|
  @users_count = UserRepository.new.count

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

When "a request is performed with an existent email" do
  # Create exitent email
  UserRepository.new.create(full_name: "Max Mustermann", email: "max@mustermann.de", password: "password")
  @users_count = UserRepository.new.count

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { user: {
    full_name: 'Max Mustermann',
    email: 'max@mustermann.de',
    password: 'password'
  } }
  post('/users', JSON.dump(json))
end

When "an account is created" do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  json = { user: {
    full_name: 'Max Mustermann',
    email: 'max@mustermann.de',
    password: 'password'
  } }
  post('/users', JSON.dump(json))
end

Then "an account should be created" do
  expect(UserRepository.new.count).to eq(@users_count+1)
end

Then /^the status code should be (\d+)$/ do |code|
  expect(last_response.status).to eq code.to_i
end

Then "an account should not be created" do
  expect(UserRepository.new.count).to eq @users_count
end

Then /^the response should include the "([^"]+)" message$/ do |error_message|
  expect(last_response.body).to match error_message
end

Then "a user token should be generated" do
  expect(UserRepository.new.first.token.length).to eq 32
end

Then "this token will be used for authentication purposes" do
  # TODO: How should I test this?
end
