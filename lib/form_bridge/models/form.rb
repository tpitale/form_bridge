module FormBridge
  class Form
    def self.from_persistance(database, attrs={})
      new(database, {
        id: attrs['id'],
        submissions: Submission.from_persistance(attrs["submissions"] || [])
      })
    end

    def self.key_for(id)
      ["form", id].join(':')
    end

    def initialize(database, attributes={})
      @database = database
      @attributes = {submissions: []}.merge(attributes)
    end

    def key
      self.class.key_for(id)
    end

    def id
      self[:id] ||= SecureRandom.uuid
    end

    def submissions
      self[:submissions]
    end

    def new?
      id.nil?
    end

    def [](key)
      @attributes[key]
    end

    def []=(key, value)
      @attributes[key] = value
    end

    def save
      @database.persist(self)
    end

    def as_json
      {
        id: id,
        submissions: submissions.map(&:as_json)
      }
    end
  end
end
