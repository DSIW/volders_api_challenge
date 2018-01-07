describe Api::Controllers::Contracts::Create do
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
  end
end
