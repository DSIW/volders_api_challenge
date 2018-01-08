describe Api::Controllers::Contracts::Show do
  let(:repository) { double(ContractRepository) }
  let(:current_user) { double(User, id: 2) }
  let(:params) { {} }
  let(:action) { described_class.new(repository) }
  let(:contract) { double(Contract, id: 1, vendor: 'Vodafone') }

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

      let(:params) { {id: 1} }

      it 'fetches contract with id and user_id' do
        expect(repository).to receive(:find_by_id_and_user_id).with(1, 2).and_return(contract)
        allow(Api::Serializers::ContractSerializer).to receive(:new).with(contract).and_return(double(to_json: 'JSON'))
        action.call(params)
      end

      it 'raises NotFoundError if contract was not found' do
        expect(repository).to receive(:find_by_id_and_user_id).and_return(nil)
        expect { action.call(params) }.to raise_error(Api::Errors::NotFoundError)
      end

      it 'body= is called with serialized contract' do
        expect(repository).to receive(:find_by_id_and_user_id).and_return(contract)
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
        expect(repository).not_to receive(:find_by_id_and_user_id)
        expect { action.call(params) } # ignore exception
      end
    end
  end
end
