require 'spec_helper'
require 'moki_ruby/device_iosprofile'

describe DeviceIOSProfile do
  let(:response_hash) { { "PayloadDisplayName" => "Belly MDM Installation",
                          "PayloadVersion" => "1",
                          "PayloadOrganization" => "Belly Inc",
                          "PayloadRemovalDisallowed" => "false",
                          "PayloadDescription" => "Allow Belly Inc to track this device, including all apps.",
                          "PayloadIdentifier" => "com.belly.mdm",
                          "PayloadContent" => [
                            {
                              "PayloadDisplayName" => "Belly",
                              "PayloadVersion" => "1",
                              "PayloadOrganization" => "Belly Inc",
                              "PayloadIdentifier" => "com.belly.mdm.com.apple.security.pkcs12.00110334-abcd-efab-cdef-123412341234",
                              "PayloadDescription" => "Identifies the device to the MDM server using SSL client certificates",
                              "PayloadType" => "com.apple.security.pkcs12"
                            },
                            {
                              "PayloadDisplayName" => "Mobile Device Management",
                              "PayloadVersion" => "1",
                              "PayloadOrganization" => "Belly Inc",
                              "PayloadIdentifier" => "com.belly.mdm.com.apple.mdm.1a2b3c4d-5e6f-7a8b-9c0d-0987654321ba",
                              "PayloadDescription" => "Configuration for MDM",
                              "PayloadType" => "com.apple.mdm"
                            }
                          ] } }

  it "will load from a hash with string keys" do
    profile = DeviceIOSProfile.from_hash(response_hash)

    expect(profile.display_name).to eq(response_hash["PayloadDisplayName"])
    expect(profile.version).to eq(response_hash["PayloadVersion"])
    expect(profile.organization).to eq(response_hash["PayloadOrganization"])
    expect(profile.removal_disallowed).to eq(response_hash["PayloadRemovalDisallowed"])
    expect(profile.description).to eq(response_hash["PayloadDescription"])
    expect(profile.identifier).to eq(response_hash["PayloadIdentifier"])
    expect(profile.content).to eq(response_hash["PayloadContent"])
  end

  it "will convert the response to a hash" do
    profile = DeviceIOSProfile.new
    profile.display_name = response_hash["PayloadDisplayName"]
    profile.version = response_hash["PayloadVersion"]
    profile.organization = response_hash["PayloadOrganization"]
    profile.removal_disallowed = response_hash["PayloadRemovalDisallowed"]
    profile.description = response_hash["PayloadDescription"]
    profile.identifier = response_hash["PayloadIdentifier"]
    profile.content = response_hash["PayloadContent"]

    expect(profile.to_hash).to eq(response_hash)
  end

  xit "will return a hash for installing" do
    profile = DeviceIOSProfile.from_hash(response_hash)
    expect(profile.install_hash).to eq({ "action" => "installprofile",
                                         "thirdPartyUser" => "moki_ruby",
                                         "clientName" => "MokiRuby",
                                         "itemName" => "Profile Name",
                                         "notify" => true,
                                         "payload" => "01234699-5767-8abc-d123-ffffffffffff" })
  end

  it "will return a hash for removal" do
    profile = DeviceIOSProfile.from_hash(response_hash)
    expect(profile.removal_hash).to eq({ "action" => "removeprofile",
                                         "thirdPartyUser" => "moki_ruby",
                                         "clientName" => "MokiRuby",
                                         "itemName" => "Belly MDM Installation",
                                         "notify" => true,
                                         "payload" => "com.belly.mdm" })
  end
end
