describe "POST /contracts" do
  include Rack::Test::Methods

  before do
    UserRepository.new.clear
  end

  let!(:user) { UserRepository.new.create(token: 'usertoken') }

  describe 'with valid params' do
    let(:params) do
      {
        contract: {
          vendor: 'Vodafone',
          starts_on: '2018-01-01T00:00:00Z',
          ends_on: '2019-01-01T00:00:00Z'
        }
      }
    end

    before do
      header 'Accept', 'application/json'
    end

    describe 'without authorization' do
      it 'responds with 401' do
        post_json "/contracts", params
        expect(last_response.status).to eq 401
      end

      it 'wont be persisted' do
        post_json "/contracts", params
        expect(ContractRepository.new.count).to eq 0
      end

      it 'responds with error' do
        post_json "/contracts", params
        json = JSON.parse(last_response.body)
        expect(json).to match({'errors' => [{'message' => "Unauthorized"}]})
      end
    end

    context 'with authorization' do
      before do
        token = Base64.encode64([user.id, 'usertoken'].join(':'))
        header 'Authorization', "Basic #{token}"
      end

      it 'responds with 201' do
        post_json "/contracts", params
        expect(last_response.status).to eq 201
      end

      it 'will be persisted' do
        post_json "/contracts", params
        expect(ContractRepository.new.count).to eq 1
      end

      it 'responds with persisted contract' do
        post_json "/contracts", params
        json = JSON.parse(last_response.body)
        expect(json["id"].to_s).to match(/\d+/)
        expect(json["vendor"]).to eq("Vodafone")
        expect(json["starts_on"]).to eq("2018-01-01T00:00:00+0000Z")
        expect(json["ends_on"]).to eq("2019-01-01T00:00:00+0000Z")
        expect(json["user_id"]).to eq(user.id)
      end
    end
  end
end
