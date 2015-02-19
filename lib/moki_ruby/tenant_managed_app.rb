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

  def install_hash
    {
      "action" => "install_app",
      "thirdPartyUser" => "moki_ruby",
      "clientName" => "MokiRuby",
      "itemName" => self.name,
      "notify" => true,
      "payload" => {
                     "ManagementFlags" => self.management_flag,
                     "identifier" => self.identifier,
                     "version" => self.version
                   }.merge(self.external_locator_hash)
    }
  end

  def management_flag
    (!manifest_url.nil? && manifest_url != "") ? 1 : 0
  end

  def external_locator_hash
    if manifest_url && manifest_url != ""
      { "ManifestURL" => manifest_url }
    else
      { "iTunesStoreID" => itunes_store_id }
    end
  end
end
