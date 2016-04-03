module FormBridge
  class CLI
    attr_accessor :options

    def initialize(args)
      self.options = {logger: Logger.new(STDOUT), port: 8080, host: 'localhost'}

      OptionParser.new do |parser|
        parser.banner = [
          "Usage: #{@name} -d /tmp/database.db\n",
          "       #{@name} --help\n"
        ].compact.join

        parser.on('-d', '--database PATH') do |path|
          self.options[:db] = FormBridge::Persistance.new(GDBM.new(path))
        end

        parser.on('-h', '--host HOST') do |host|
          self.options[:host] = host
        end

        parser.on('-p', '--port PORT') do |port|
          self.options[:port] = port
        end

        parser.on_tail("-?", "--help", "Display this usage information.") do
          puts "#{parser}\n"
          exit
        end
      end.parse!(args)
    end

    def start
      FormBridge.map(options) do
        get "/forms/new",
          FormBridge::Endpoint::Forms::New.new(options[:db])

        get "/forms",
          FormBridge::Endpoint::Forms::Show.new(options[:db])

        post "/submissions",
          FormBridge::Endpoint::Submissions::Create.new(options[:db])
      end.run
    end
  end
end
