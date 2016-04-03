module FormBridge
  class Handler
    def initialize(options, app)
      @options = options
      @app = app
    end

    def puma_options
      {
        :Port => @options[:port],
        :Host => @options[:host]
      }
    end

    def run
      Rack::Handler::Puma.run @app, puma_options
    end
  end
end
