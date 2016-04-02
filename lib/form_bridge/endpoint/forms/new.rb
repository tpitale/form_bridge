module FormBridge
  module Endpoint
    module Forms
      class New
        def initialize(database)
          @database = database
        end

        def call(request)
          # make a securerandom uuid
          # display URL
          # display instructions
          form = Form.new(@database)
          form.save

          [200, {"Content-Type" => "text/plain"}, [form.id.to_s]]
        end
      end
    end
  end
end
