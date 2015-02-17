require 'spec_helper'
require 'moki_ruby/device_managed_app'

describe DeviceManagedApp do
  let(:response_hash) { { "Status" => "Managed",
                          "appIdentifier" => "com.belly.gem.moki.enterprise",
                          "ManagementFlags" => 0 } }

  let(:attrs) { %w(Status appIdentifier ManagementFlags) }

  it "will load from a hash with string keys" do
    profile = DeviceManagedApp.from_hash(response_hash)
    expect(profile.status).to eq(response_hash["Status"])
    expect(profile.app_identifier).to eq(response_hash["appIdentifier"])
    expect(profile.management_flags).to eq(response_hash["ManagementFlags"])
  end

  it "will convert the response to a hash" do
    profile = DeviceManagedApp.new
    attrs.each do |attribute|
      profile.status = "Managed"
      profile.app_identifier = "com.belly.gem.moki.enterprise"
      profile.management_flags = 0
    end
    expect(profile.to_hash).to eq(response_hash)
  end
end
