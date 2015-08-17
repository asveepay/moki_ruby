module MokiRuby
  class TenantIOSProfile
    attr_accessor :id, :last_seen, :name, :display_name, :description, :identifier

    def self.from_hash(input_hash)
      new_profile = self.new
      new_profile.id = input_hash["id"]
      new_profile.last_seen = input_hash["lastSeen"]
      new_profile.name = input_hash["name"]
      new_profile.display_name = input_hash["displayName"]
      new_profile.description = input_hash["description"]
      new_profile.identifier = input_hash["identifier"]

      new_profile
    end

    def to_hash
      {
        "id" => self.id,
        "lastSeen" => self.last_seen,
        "name" => self.name,
        "displayName" => self.display_name,
        "description" => self.description,
        "identifier" => self.identifier
      }
    end

    def install_hash
      actionable_hash.merge({ "action" => "installprofile",
                              "payload" => "#{ self.id }" })
    end

    def removal_hash
      actionable_hash.merge({ "action" => "removeprofile",
                              "payload" => "{#{ self.identifier }}" })
    end

  private
    def actionable_hash
      {
        "thirdPartyUser" => "moki_ruby",
        "clientName" => "MokiRuby",
        "itemName" => self.name,
        "notify" => true
      }
    end
  end
end
