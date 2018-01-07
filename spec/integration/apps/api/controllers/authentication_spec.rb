describe Api::Controllers::Authentication do
  class Api::Controllers::Authentication::IntegrationTestController
    include Api::Action
    include Api::Controllers::Authentication

    configuration.handle_exceptions false

    def call(params)
      status 200, 'body'
    end
  end

  let(:action) { Api::Controllers::Authentication::IntegrationTestController.new }

  describe 'without Authorization header' do
    it 'raises PermissionDeniedError' do
      expect { action.call({}) }.to raise_error(Api::Errors::PermissionDeniedError)
    end
  end

  describe 'with correct Authorization header' do
    it 'does not raise PermissionDeniedError' do
      user = UserRepository.new.create(full_name: 'Max Mustermann', token: 'usertoken')
      params = {
        'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64([user.id, 'usertoken'].join(':')).chomp}"
      }
      action.call(params)
    end
  end
end
