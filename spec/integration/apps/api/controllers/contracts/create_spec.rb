describe Api::Controllers::Contracts::Create do
  let!(:user) { UserRepository.new.create(full_name: 'Max Mustermann', token: 'usertoken') }

  let(:repository) { ContractRepository.new }
  let(:action) { described_class.new(repository) }
  let(:params) { {} }

  describe '#call' do
    before do
      repository.clear
    end

    describe 'without authorization' do
      it 'raises PermissionDeniedError' do
        expect { action.call(params) }.to raise_error(Api::Errors::PermissionDeniedError)
      end
    end

    describe 'with authorization' do
      let(:params) do
        {
          contract: {
            vendor: 'Vodafone',
            starts_on: '2018-01-01T00:00:00Z',
            ends_on: '2019-01-01T00:00:00Z',
          },
          'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64([user.id, 'usertoken'].join(':')).chomp}"
        }
      end

      describe 'with valid params' do
        it 'contract will be persisted' do
          action.call(params)
          expect(repository.count).to eq 1
        end

        it 'sets status to 201' do
          response = action.call(params)
          status, headers, body = response

          expect(status).to eq 201
        end

        it 'responds with serialized contract' do
          response = action.call(params.dup) # NOTE: controller modifies params
          status, headers, body = response
          json = JSON.parse(body[0])

          expect(json['id'].to_s).to match /\d+/
          expect(json['vendor']).to eq "Vodafone"
          expect(json['starts_on']).to eq "2018-01-01T00:00:00+0000Z"
          expect(json['ends_on']).to eq "2019-01-01T00:00:00+0000Z"
          expect(json['user_id']).to eq user.id
        end
      end
    end
  end
end
