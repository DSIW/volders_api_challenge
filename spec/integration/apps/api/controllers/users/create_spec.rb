describe Api::Controllers::Users::Create do
  let(:repository) { UserRepository.new }
  let(:action) { described_class.new(repository) }

  before do
    repository.clear
  end

  let(:valid_params) do
    {'user' => {
      'full_name' => 'Max Mustermann',
      'email' => 'max@mustermann.de',
      'password' => 'password'
    }}
  end

  describe 'with valid params' do
    let(:params) { valid_params }

    it 'will be persisted' do
      response = action.call(params)
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
  end
end