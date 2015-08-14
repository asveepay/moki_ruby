module MokiRuby
  class DeviceIOSProfile
    attr_accessor :display_name, :version, :organization,
                  :removal_disallowed, :description, :identifier, :content

    def self.from_hash(input_hash)
      new_profile = self.new

      new_profile.display_name = input_hash["PayloadDisplayName"]
      new_profile.version = input_hash["PayloadVersion"]
      new_profile.organization = input_hash["PayloadOrganization"]
      new_profile.removal_disallowed = input_hash["PayloadRemovalDisallowed"]
      new_profile.description = input_hash["PayloadDescription"]
      new_profile.identifier = input_hash["PayloadIdentifier"]
      new_profile.content = input_hash["PayloadContent"]

      new_profile
    end

    def to_hash
      {
        "PayloadDisplayName" => self.display_name,
        "PayloadVersion" => self.version,
        "PayloadOrganization" => self.organization,
        "PayloadRemovalDisallowed" => self.removal_disallowed,
        "PayloadDescription" => self.description,
        "PayloadIdentifier" => self.identifier,
        "PayloadContent" => self.content
      }
    end

    def install_hash
      raise "under construction"
      actionable_hash.merge({ "action" => "installprofile",
                              "payload" => "#{ self.id }" })
    end

    def removal_hash
      actionable_hash.merge({ "action" => "removeprofile",
                              "payload" => "#{ self.identifier }" })
    end

  private
    def actionable_hash
      {
        "thirdPartyUser" => "moki_ruby",
        "clientName" => "MokiRuby",
        "itemName" => self.display_name,
        "notify" => true
      }
    end
  end
end
