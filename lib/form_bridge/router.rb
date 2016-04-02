module FormBridge
  # middleware which matches rack request
  class Router
    GET = 'GET'
    POST = 'POST'

    def self.build(options, &block)
      Rack::Builder.new do
        use Rack::CommonLogger

        run FormBridge::Router.new(options, &block)
      end
    end

    class Route
      def initialize(verb, path, endpoint)
        @verb = verb
        @path = path
        @endpoint = endpoint
      end

      def match_path?(request)
        # does request match on path
        request.path == @path
      end

      def match_verb?(request)
        # does request match on verb
        request.request_method == @verb
      end

      def call(request)
        @endpoint.call(request)
      end
    end

    class NotFoundRoute
      def match_path?(*)
        true
      end

      def match_verb?(*)
        true
      end

      def call(*)
        [404, { "Content-Type" => "text/plain" }, ["NOT_FOUND"]]
      end
    end

    attr_reader :options

    def initialize(options, &block)
      @options = options
      @routes = [] # this is fine for now because we only have two routes

      instance_eval(&block)

      # we want to force this as the last
      @routes << NotFoundRoute.new
    end

    def logger
      options[:logger]
    end

    def get(path, endpoint)
      route(GET, path, endpoint)
    end

    def post(path, endpoint)
      route(POST, path, endpoint)
    end

    def route(verb, path, endpoint)
      @routes << Route.new(verb, path, endpoint)
    end

    def call(env)
      request = Rack::Request.new(env)

      begin
        @routes.detect do |route|
          route.match_verb?(request) && route.match_path?(request)
        end.call(request)
      rescue => e
        puts e.message
        puts e.backtrace

        [500, { "Content-Type" => "text/plain" }, ["SERVER_ERROR"]]
      end
    end
  end
end
