module FormBridge
  class Submission
    def self.type
      self.class.name.downcase
    end

    def self.from_persistance(collection=[])
      collection.map do |attributes|
        new(id: attributes["id"]).append_all(attributes)
      end
    end

    def self.from_params(params={})
      new(email: params.delete("_replyto")).append_all(params)
    end

    def initialize(attributes={})
      @attributes = {id: SecureRandom.uuid}.merge(attributes)
    end

    def append_all(attributes={})
      puts "Appending:"
      p attributes

      attributes.each {|k,v| append(k,v)}
      self
    end

    def append(key, value)
      return if key.start_with?("_") || value.to_s.length < 1

      @attributes[key.to_sym] = value
    end

    def as_json
      @attributes
    end
  end
end
