describe Api::Controllers::Users::Create do
  let(:repository) { UserRepository.new }
  let(:action) { described_class.new(repository) }

  before do
    repository.clear
  end

  describe 'with valid params' do
    let(:params) do
      {'user' => {
        'full_name' => 'Max Mustermann',
        'email' => 'max@mustermann.de',
        'password' => 'password'
      }}
    end

    it 'will be persisted' do
      action.call(params)
      expect(repository.count).to eq 1
    end

    it 'responds with created user' do
      response = action.call(params.dup) # NOTE: controller modifies params
      status, headers, body = response
      json = JSON.parse(body[0])

      expect(status).to eq 201

      expect(json.keys).to match ['id', 'full_name', 'email']
      expect(json['id'].to_s).to match /\d+/
      expect(json['full_name']).to eq "Max Mustermann"
      expect(json['email']).to eq "max@mustermann.de"
      expect(json).not_to have_key('password')
    end

    it 'assigns a token to user' do
      action.call(params)
      expect(repository.first.token.length).to be > 32
    end
  end

  describe 'with invalid params (empty full_name)' do
    let(:params) do
      {'user' => {
        'full_name' => '',
        'email' => 'max@mustermann.de',
        'password' => 'password'
      }}
    end

    it 'will not be persisted' do
      expect { action.call(params) }.to raise_error(Api::Errors::ValidationError)
      expect(repository.count).to eq 0
    end
  end

  describe 'with existent email' do
    let(:params) do
      {'user' => {
        'full_name' => 'Max Mustermann',
        'email' => 'max@mustermann.de',
        'password' => 'password'
      }}
    end

    before do
      repository.create({
        full_name: 'Existing user',
        email: 'max@mustermann.de',
        password: 'abc'
      })
    end

    it 'will not be persisted' do
      expect(repository.count).to eq 1
      expect { action.call(params) }.to raise_error(Api::Errors::ValidationError)
      expect(repository.count).to eq 1
    end
  end
end
