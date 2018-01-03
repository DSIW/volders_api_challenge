describe Api::Controllers::Users::Create do
  let(:repository) { double('Repository') }
  let(:serializer) { instance_double(Serializer, to_json: body) }
  let(:body) { '{"full_name": "Max"}' }
  let(:action) { described_class.new(repository) }

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
    let(:params) { {user: {full_name: 'Max'}} }
    let(:user) { double(User, full_name: 'Max') }

    before do
      allow(Serializer).to receive(:new)
        .with(user, [:id, :full_name, :email])
        .and_return(serializer)
      allow(repository).to receive(:create).and_return(user)
    end

    it 'creates user with params' do
      expect(repository).to receive(:create).with({full_name: 'Max'})
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
end
