# Authentication module using HTTP Basic Auth
module Api::Controllers
  module Authentication
    def self.included(action)
      action.class_eval do
        before :authenticate!
      end
    end

    private

    def authenticate!
      raise Api::Errors::PermissionDeniedError unless authenticated?
    end

    def authenticated?
      !!current_user
    end

    # Format of HTTP request header:
    # Authorization: Basic MTo3MmRmMDc4M2RlZjhlMTEzZjU2ZDgyMjVkYTY5MjU0MQ==
    def current_user
      @current_user ||= begin
        authorization = params.env['HTTP_AUTHORIZATION']
        return nil unless authorization

        token = Token.new(authorization.gsub('Basic ', ''))
        user = UserRepository.new.find(token.identifier.to_i)
        return nil unless user
        return nil unless token.check(user.token)
        user
      end
    end
  end
end
