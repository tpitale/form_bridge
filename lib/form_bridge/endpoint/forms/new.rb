module FormBridge
  module Endpoint
    module Forms
      class New
        INSTRUCTIONS = [
          "Save this information!",
          "Keep the private id and form url to yourself,",
          "it accesses all the data submitted to the submission_url.",
          "Use the submission_url for your form."
        ].join(' ')

        def initialize(database)
          @database = database
        end

        def call(request)
          # make a pair of securerandom uuids, public and private
          # display URL for submissions
          # display instructions
          form = Form.new(@database)
          form.save

          # map public_id to form id (private)
          public_id = SecureRandom.uuid
          @database.map(public_id, form.id)

          response = response_hash(public_id, form.id, base_uri_for(request))

          [200, {"Content-Type" => "application/json"}, [JSON.dump(response)]]
        end

        def base_uri_for(request)
          URI(request.url).tap do |uri|
            uri.path = ''
          end
        end

        def response_hash(public_id, private_id, base_uri)
          submission_url = base_uri.dup.tap do |uri|
            uri.path = '/submissions'
            uri.query = URI.encode_www_form(form_id: public_id)
          end

          form_url = base_uri.dup.tap do |uri|
            uri.path = '/forms'
            uri.query = URI.encode_www_form(id: private_id)
          end

          {
            private_id: private_id,
            public_id: public_id,
            submission_url: submission_url,
            form_url: form_url,
            instructions: instructions
          }
        end

        def instructions
          INSTRUCTIONS
        end
      end
    end
  end
end
