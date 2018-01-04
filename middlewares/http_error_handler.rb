module Middlewares
  class HttpErrorHandler
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call env
    rescue Api::Errors::HttpError => e
      [e.status, e.headers, [e.body]]
    end
  end
end
