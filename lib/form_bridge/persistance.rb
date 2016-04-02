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

    private
    def raw(id)
      @database[Form.key_for(id)]
    end
  end
end
