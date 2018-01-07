describe Api::Controllers::Authentication do
  class Api::Controllers::Authentication:: UnitTestController
    @@before_method = nil

    def self.before(method)
      @@before_method = method
    end

    def self.before_method
      @@before_method
    end

    include Api::Controllers::Authentication

    def params
      OpenStruct.new(env: headers)
    end

    def headers
      {}
    end
  end

  before do
    allow_any_instance_of(UserRepository).to receive(:find).and_return(user)
    allow(Token).to receive(:new).and_return(token)
  end

  let(:action) { Api::Controllers::Authentication:: UnitTestController.new }
  let(:user) { double('User', id: '1', token: 'secret') }
  let(:token) { double(Token) }

  describe '.before' do
    it 'is called' do
      expect(Api::Controllers::Authentication:: UnitTestController.before_method).to eq :authenticate!
    end
  end

  describe '#current_user' do
    describe 'without Authorization header' do
      it 'returns nil' do
        expect(action.send(:current_user)).to be nil
      end
    end

    describe 'on wrong user id' do
      let(:user) { nil }
      it 'returns nil' do
        expect(action.send(:current_user)).to be nil
      end
    end

    describe 'on wrong secret' do
      it 'returns nil' do
        allow(token).to receive(:check).and_return(false)
        expect(action.send(:current_user)).to be nil
      end
    end

    describe 'on correct authentication' do
      before do
        allow(action).to receive(:headers) { { 'HTTP_AUTHORIZATION' => "Basic abc" } }
        allow(Token).to receive(:new).with('abc').and_return(token)
        allow(token).to receive(:identifier) { 1 }
      end

      it 'returns the authenticated user' do
        expect(token).to receive(:check).with('secret').and_return(true)
        expect(action.send(:current_user)).to eq user
      end

      it 'is memorized' do
        allow(token).to receive(:check).and_return(true).once
        action.send(:current_user)
        action.send(:current_user)
      end
    end
  end

  describe '#authenticated?' do
    it 'returns true if current_user is set' do
      allow(action).to receive(:current_user).and_return(user)
      expect(action.send(:authenticated?)).to be true
    end

    it 'returns false if current_user is nil' do
      allow(action).to receive(:current_user).and_return(nil)
      expect(action.send(:authenticated?)).to be false
    end
  end

  describe '#authenticate!' do
    it 'raises PermissionDeniedError unless authenticated' do
      allow(action).to receive(:authenticated?).and_return(false)
      expect { action.send(:authenticate!) }.to raise_error(Api::Errors::PermissionDeniedError)
    end

    it 'does not raise PermissionDeniedError if authenticated' do
      allow(action).to receive(:authenticated?).and_return(true)
      action.send(:authenticate!)
    end
  end
end
