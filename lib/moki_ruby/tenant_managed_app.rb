class TenantManagedApp
  attr_accessor :id, :last_seen, :name, :identifier, :version,
                :management_flags, :itunes_store_id, :manifest_url

  def self.from_hash(input_hash)
    new_app = self.new
    new_app.id = input_hash["id"]
    new_app.last_seen = input_hash["lastSeen"]
    new_app.name = input_hash["name"]
    new_app.identifier = input_hash["identifier"]
    new_app.version = input_hash["version"]
    new_app.management_flags = input_hash["ManagementFlags"]
    new_app.itunes_store_id = input_hash["iTunesStoreID"]
    new_app.manifest_url = input_hash["ManifestURL"]

    new_app
  end

  def to_hash
    { "id" => self.id,
      "lastSeen" => self.last_seen,
      "name" => self.name,
      "identifier" => self.identifier,
      "version" => self.version,
      "ManagementFlags" => self.management_flags,
      "iTunesStoreID" => self.itunes_store_id,
      "ManifestURL" => self.manifest_url }
  end
end
