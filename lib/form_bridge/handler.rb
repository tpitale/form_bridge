module FormBridge
  class Handler
    def initialize(app)
      @app = app
    end

    def run
      Rack::Handler::Puma.run @app
    end
  end
end
