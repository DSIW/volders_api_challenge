describe Api::Controllers::Contracts::Create do
  let(:repository) { double(ContractRepository) }
  let(:current_user) { double(User, id: 1) }
  let(:params) { {} }
  let(:action) { described_class.new(repository) }

  it 'includes Api::Action' do
    expect(described_class.ancestors).to include(Api::Action)
  end

  it 'includes Api::Controllers::Authentication' do
    expect(described_class.ancestors).to include(Api::Controllers::Authentication)
  end

  describe '.new' do
    it 'accepts nothing' do
      expect(described_class.new).to be_a described_class
    end

    it 'accepts repository' do
      expect(described_class.new(repository)).to be_a described_class
    end
  end

  describe '#call' do
    describe 'with authorization' do
      before do
        allow(action).to receive(:current_user).and_return(current_user)
        allow(action).to receive(:authenticated?).and_return(true)
      end

      let(:params) do
        {
          contract: {
            vendor: 'Vodafone',
            starts_on: '2018-01-01T00:00:00Z',
            ends_on: '2019-01-01T00:00:00Z',
          }
        }
      end

      it 'persists contract with user_id' do
        expect(repository).to receive(:create).with({
          vendor: 'Vodafone',
          starts_on: '2018-01-01T00:00:00Z',
          ends_on: '2019-01-01T00:00:00Z',
          user_id: 1
        })
        allow(Api::Serializers::ContractSerializer).to receive(:new).and_return(double(to_json: 'JSON'))
        action.call(params)
      end

      it 'body= is called with serialized contract' do
        contract = double(Contract)
        expect(repository).to receive(:create).and_return(contract)
        expect(Api::Serializers::ContractSerializer).to receive(:new).with(contract).and_return(double(to_json: 'JSON'))
        expect(action).to receive(:body=).with('JSON')
        action.call(params)
      end
    end

    describe 'without authorization' do
      before do
        allow(action).to receive(:authenticated?).and_return(false)
      end

      it 'raises PermissionDeniedError' do
        expect { action.call(params) }.to raise_error(Api::Errors::PermissionDeniedError)
      end

      it 'does not persist contract' do
        expect(repository).not_to receive(:create)
        expect { action.call(params) } # ignore exception
      end
    end
  end
end
