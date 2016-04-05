module RequestGlobal
  class Railtie < ::Rails::Railtie
    initializer "request_global.insert_middleware" do |app|
      app.config.middleware.insert_after ActionDispatch::RequestId, RequestGlobal::Middleware
      ActionDispatch::Reloader.to_cleanup do
        RequestGlobal.clear_all!
      end
    end
  end
end
