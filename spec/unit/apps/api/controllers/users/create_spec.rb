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
    let(:user) { double(User, full_name: 'Max') }

    context 'with valid params' do
      let(:params) do
        { user: {
          'full_name' => 'Max Mustermann',
          'email' => 'max@mustermann.de',
          'password' => 'password'
        } }
      end

      before do
        allow(Api::Serializers::ModelSerializer).to receive(:new)
          .with(user, [:id, :full_name, :email])
          .and_return(serializer)
        allow(repository).to receive(:create).and_return(user)
      end

      it 'creates user with params' do
        expect(repository).to receive(:create).with({full_name: 'Max Mustermann', email: 'max@mustermann.de', password: 'password'})
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

      it 'does not create user' do
        expect(repository).not_to receive(:create)
        action.call(params)
      end

      it 'sets status to 422' do
        expect(action).to receive(:status=).with(422)
        action.call(params)
      end

      it 'sets serialized error as body' do
        body = '{"errors":{"full_name":[{"message":"Full Name should not be empty"}]}}'
        expect(action).to receive(:body=).with(body)
        action.call(params)
      end
    end
  end
end
