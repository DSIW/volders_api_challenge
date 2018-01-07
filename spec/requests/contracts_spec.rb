describe "POST /contracts" do
  include Rack::Test::Methods

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
  end
end
