module FormBridge
  class Persistance
    def initialize(database)
      @database = database
    end

    def persist(form)
      @database[form.key] = JSON.dump(form.as_json)
    end

    def get(id)
      Form.from_persistance(self, JSON.load(raw(id)))
    end

    # the form id is kept private for accessing data
    # so we map a public id for submission creation
    def map(public_id, private_id)
      @database["map:"+public_id.to_s] = private_id
    end

    def lookup(public_id)
      @database["map:"+public_id.to_s]
    end

    private
    def raw(id)
      @database[Form.key_for(id)]
    end
  end
end
