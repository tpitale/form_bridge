module FormBridge
  module Endpoint
    module Submissions
      class Create
        def initialize(database)
          @database = database
        end

        def call(request)
          location = request.params["_next"]
          form = @database.get(request.params["form_id"])

          form.submissions << Submission.from_params(request.params)
          form.save
          
          [302, {"Location" => location}, []]
        end
      end
    end
  end
end
