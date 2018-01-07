describe Api::Controllers::Users::Create do
  let(:action) { described_class.new(repository) }
  let(:repository) { double('Repository') }

  describe "#new" do
    it 'accepts nothing and uses default repository' do
      expect(UserRepository).to receive(:new)
      expect(described_class.new).to be_a described_class
    end

    it 'accepts repository for dependency injection' do
      expect(described_class.new(repository)).to be_a described_class
    end
  end

  describe "#call" do
    let(:serializer) { instance_double(Api::Serializers::ModelSerializer, to_json: body) }
    let(:body) { '{"full_name": "Max"}' }
    let(:user) { instance_double(User, id: 1) }

    before do
      allow(Api::Serializers::ModelSerializer).to receive(:new)
        .with(user, [:id, :full_name, :email])
        .and_return(serializer)
      allow(repository).to receive(:create).and_return(user)
      allow(repository).to receive(:update).and_return(user)
    end

    context 'with valid params' do
      let(:params) do
        { user: {
          'full_name' => 'Max Mustermann',
          'email' => 'max@mustermann.de',
          'password' => 'password'
        } }
      end

      it 'creates user with params and token' do
        expect(repository).to receive(:create).with({
          full_name: 'Max Mustermann',
          email: 'max@mustermann.de',
          password: 'password'
        }).and_return(user)
        expect(Token).to receive(:generate).with(1, 32).and_return(double(Token, base64_encoded: 'token'))
        expect(repository).to receive(:update).with(1, token: 'token')
        action.call(params)
      end

      it 'sets status to 201' do
        expect(action).to receive(:status=).with(201)
        action.call(params)
      end

      it 'sets serialized body' do
        expect(action).to receive(:body=).with(body)
        action.call(params)
      end
    end

    describe 'with invalid params' do
      let(:params) do
        { user: {
          'full_name' => '',
          'email' => 'max@mustermann.de',
          'password' => 'password'
        } }
      end

      it 'raises an error' do
        expect(repository).not_to receive(:create)
        expect { action.call(params) }.to raise_error(Api::Errors::ValidationError)
      end
    end

    describe 'with existent email' do
      let(:params) do
        { user: {
          'full_name' => 'Max Mustermann',
          'email' => 'max@mustermann.de',
          'password' => 'password'
        } }
      end

      it 'raises an error' do
        expect(repository).to receive(:create).and_raise Hanami::Model::UniqueConstraintViolationError.new
        excpetion = Api::Errors::ValidationError.new(nil)
        expect(Api::Errors::ValidationError).to receive(:new).with({email: ['is already taken']}).and_return(excpetion)
        expect { action.call(params) }.to raise_error(excpetion)
      end
    end
  end
end
