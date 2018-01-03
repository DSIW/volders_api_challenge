require 'spec_helper'

describe "POST /users" do
  include Rack::Test::Methods

  before do
    UserRepository.new.clear
  end

  describe 'with valid params' do
    let(:params) do
      {
        user: {
          full_name: 'Max Mustermann',
          email: 'max@mustermann.de',
          password: 'password'
        }
      }
    end

    before do
      header 'Accept', 'application/json'
    end

    it 'responds with 201' do
      post_json "/users", params
      expect(last_response.status).to eq 201
    end

    it 'will be persisted' do
      post_json "/users", params
      expect(UserRepository.new.count).to eq 1
    end

    it 'responds with persisted user' do
      post_json "/users", params
      json = JSON.parse(last_response.body)
      expect(json["id"].to_s).to match(/\d+/)
      # expect(json["type"]).to eq("users")
      expect(json["full_name"]).to eq("Max Mustermann")
      expect(json["email"]).to eq("max@mustermann.de")
    end
  end
end
