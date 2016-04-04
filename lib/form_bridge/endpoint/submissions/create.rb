module FormBridge
  module Endpoint
    module Submissions
      class Create
        def initialize(database)
          @database = database
        end

        def call(request)
          # ensure we set a creation timestamp for later de-duplication
          request.params["created_at"] ||= Time.now.to_i

          location = request.params["_next"]
          form = form_for(request.params["form_id"])

          form.submissions << Submission.from_params(request.params)
          form.save

          [302, {"Location" => location}, []]
        end

        def form_for(public_id)
          @database.get(@database.lookup(public_id))
        end
      end
    end
  end
end
