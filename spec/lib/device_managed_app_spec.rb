require 'spec_helper'
require 'moki_ruby/device_managed_app'

describe DeviceManagedApp do
  let(:response_hash) { { "Status" => "Managed",
                          "appIdentifier" => "com.belly.gem.moki.enterprise",
                          "ManagementFlags" => 0 } }

  it "will load from a hash with string keys" do
    app = DeviceManagedApp.from_hash(response_hash)
    expect(app.status).to eq(response_hash["Status"])
    expect(app.app_identifier).to eq(response_hash["appIdentifier"])
    expect(app.management_flags).to eq(response_hash["ManagementFlags"])
  end

  it "will convert the response to a hash" do
    app = DeviceManagedApp.new
    app.status = "Managed"
    app.app_identifier = "com.belly.gem.moki.enterprise"
    app.management_flags = 0

    expect(app.to_hash).to eq(response_hash)
  end

  it "will return a hash for removal" do
    app= DeviceManagedApp.from_hash(response_hash)
    expect(app.uninstall_hash).to eq({
                                       "action" => "remove_app",
                                       "thirdPartyUser" => "moki_ruby",
                                       "clientName" => "MokiRuby",
                                       "itemName" => "iOS App",
                                       "notify" => true,
                                       "payload" => response_hash["appIdentifier"] })
  end
end
