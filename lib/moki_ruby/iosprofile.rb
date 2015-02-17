class IOSProfile
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
end
