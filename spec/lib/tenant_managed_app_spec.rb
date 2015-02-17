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
end
