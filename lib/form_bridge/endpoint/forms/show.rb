module FormBridge
  module Endpoint
    module Forms
      class Show
        def initialize(database)
          @database = database
        end

        def call(request)
          id = request.params["id"]
          form = @database.get(id)

          # return form submissions as json
          data = JSON.dump form.submissions.map(&:as_json)
          [200, {"Content-Type" => "application/json"}, [data]]
        end
      end
    end
  end
end
