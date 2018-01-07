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
