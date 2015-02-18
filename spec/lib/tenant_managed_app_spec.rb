require 'spec_helper'
require 'moki_ruby/tenant_managed_app'

describe TenantManagedApp do
  let(:response_hash) { { "id" => "30dedb70­62a9­41b8­b5f0­c960d7d8f79a",
                          "lastSeen" => 1384278494336,
                          "name" => "MokiTouch 2.0",
                          "identifier" => "com.mokimobility.mokitouch2",
                          "version" => "1.1.1",
                          "ManagementFlags" => 0,
                          "iTunesStoreID" => "733151730",
                          "ManifestURL" => "http://www.mokimanage.com/app" } }

  it "will load from a hash with string keys" do
    app = TenantManagedApp.from_hash(response_hash)
    expect(app.id).to eq(response_hash["id"])
    expect(app.last_seen).to eq(response_hash["lastSeen"])
    expect(app.name).to eq(response_hash["name"])
    expect(app.identifier).to eq(response_hash["identifier"])
    expect(app.version).to eq(response_hash["version"])
    expect(app.management_flags).to eq(response_hash["ManagementFlags"])
    expect(app.itunes_store_id).to eq(response_hash["iTunesStoreID"])
    expect(app.manifest_url).to eq(response_hash["ManifestURL"])
  end

  it "will convert the response to a hash" do
    app = TenantManagedApp.new
    app.id = "30dedb70­62a9­41b8­b5f0­c960d7d8f79a"
    app.last_seen = 1384278494336
    app.name = "MokiTouch 2.0"
    app.identifier = "com.mokimobility.mokitouch2"
    app.version = "1.1.1"
    app.management_flags = 0
    app.itunes_store_id = "733151730"
    app.manifest_url = "http://www.mokimanage.com/app"

    expect(app.to_hash).to eq(response_hash)
  end

  describe "management_flag" do
    it "returns 1 if the device has a manifest url" do
      app = TenantManagedApp.from_hash({"ManifestURL" => "https://www.mokimanage.com"})
      expect(app.management_flag).to eq(1)
    end

    it "returns 0 if the device has an iTunesStoreID" do
      app = TenantManagedApp.from_hash({"iTunesStoreID" => "733151730"})
      expect(app.management_flag).to eq(0)
    end
  end

  describe "external_locator_hash" do
    it "returns a hash with the manifest url if it has one" do
      app = TenantManagedApp.from_hash({"ManifestURL" => "https://www.mokimanage.com"})
      expect(app.external_locator_hash).to eq({"ManifestURL" => "https://www.mokimanage.com"})
    end

    it "returns a hash with the itunes store id if it does not have a manifest url" do
      app = TenantManagedApp.from_hash({"iTunesStoreID" => "733151730"})
      expect(app.external_locator_hash).to eq({"iTunesStoreID" => "733151730"})
    end
  end
end
