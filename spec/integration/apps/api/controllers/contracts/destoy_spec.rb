describe Api::Controllers::Contracts::Destroy do
  let!(:user) { UserRepository.new.create(full_name: 'Max Mustermann', token: 'usertoken') }
  let!(:other_user) { UserRepository.new.create(full_name: 'Max Mustermann', token: 'otherusertoken') }
  let!(:contract) { ContractRepository.new.create(vendor: 'Vodafone', user_id: user.id) }
  let!(:other_contract) { ContractRepository.new.create(vendor: 'Vodafone', user_id: other_user.id) }

  let(:repository) { ContractRepository.new }
  let(:action) { described_class.new(repository) }
  let(:params) { {} }

  describe '#call' do
    describe 'without authorization' do
      it 'raises PermissionDeniedError' do
        expect { action.call(params) }.to raise_error(Api::Errors::PermissionDeniedError)
      end
    end

    describe 'with authorization' do
      let(:params) do
        {
          id: contract.id,
          'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64([user.id, 'usertoken'].join(':')).chomp}"
        }
      end

      describe 'with valid id' do
        it 'deletes the contract' do
          response = action.call(params)
          status, headers, body = response

          expect(ContractRepository.new.find(contract.id)).to be nil
        end

        it 'sets status to 200' do
          response = action.call(params)
          status, headers, body = response

          expect(status).to eq 200
        end

        it 'responds with serialized contract' do
          response = action.call(params)
          status, headers, body = response
          json = JSON.parse(body[0])

          expect(json).to eq({
            'id' => contract.id,
            'vendor' => 'Vodafone',
            'starts_on' => nil,
            'ends_on' => nil,
            'user_id' => user.id
          })
        end
      end

      describe 'with invalid id' do
        let(:params) do
          {
            id: 0,
            'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64([user.id, 'usertoken'].join(':')).chomp}"
          }
        end

        it "raises a NotFoundError" do
          expect { action.call(params) }.to raise_error(Api::Errors::NotFoundError)
        end

        it 'does not delete the contract' do
          expect { action.call(params) } # ignore exception
          expect(ContractRepository.new.find(contract.id)).to eq contract
        end
      end

      describe 'with other user_id' do
        let(:params) do
          {
            id: other_contract.id,
            'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64([user.id, 'usertoken'].join(':')).chomp}"
          }
        end

        it "raises a NotFoundError" do
          expect { action.call(params) }.to raise_error(Api::Errors::NotFoundError)
        end

        it 'does not delete the contract' do
          expect { action.call(params) } # ignore exception
          expect(ContractRepository.new.find(contract.id)).to eq contract
        end
      end
    end
  end
end
