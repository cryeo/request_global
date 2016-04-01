require 'securerandom'

module RequestGlobal
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      result = nil
      begin
        RequestGlobal.set_current_request current_request_id(env)
        RequestGlobal.begin!
        result = @app.call(env)
      ensure
        RequestGlobal.end!
      end
      result
    end

    protected
    def current_request_id(env)
      if env["action_dispatch.request_id"]
        env["action_dispatch.request_id"]
      elsif request_id = env["HTTP_X_REQUEST_ID"]
        request_id.gsub(/[^\w\-]/, "")[0, 255]
      else
        SecureRandom.uuid
      end
    end
  end
end
