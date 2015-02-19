require 'spec_helper'
require 'moki_ruby/iosprofile'

describe IOSProfile do
  let(:response_hash) { { "id" => "01234699-5767-8abc-d123-ffffffffffff",
                          "lastSeen" => 1413913980475,
                          "name" => "Profile Name",
                          "displayName" => "Profile Display Name",
                          "description" => "Profile Description",
                          "identifier" => "abcdef12345-abc-123-ffeea.test" } }

  it "will load from a hash with string keys" do
    profile = IOSProfile.from_hash(response_hash)

    expect(profile.id).to eq(response_hash["id"])
    expect(profile.last_seen).to eq(response_hash["lastSeen"])
    expect(profile.name).to eq(response_hash["name"])
    expect(profile.display_name).to eq(response_hash["displayName"])
    expect(profile.description).to eq(response_hash["description"])
    expect(profile.identifier).to eq(response_hash["identifier"])
  end

  it "will convert the response to a hash" do
    profile = IOSProfile.new
    profile.id = response_hash["id"]
    profile.last_seen = response_hash["lastSeen"]
    profile.name = response_hash["name"]
    profile.display_name = response_hash["displayName"]
    profile.description = response_hash["description"]
    profile.identifier = response_hash["identifier"]

    expect(profile.to_hash).to eq(response_hash)
  end

  it "will return a hash for installing" do
    profile = IOSProfile.from_hash(response_hash)
    expect(profile.install_hash).to eq({ "action" => "installprofile",
                                         "thirdPartyUser" => "moki_ruby",
                                         "clientName" => "MokiRuby",
                                         "itemName" => "Profile Name",
                                         "notify" => true,
                                         "payload" => "{01234699-5767-8abc-d123-ffffffffffff}" })
  end

  it "will return a hash for removal" do
    profile = IOSProfile.from_hash(response_hash)
    expect(profile.removal_hash).to eq({ "action" => "removeprofile",
                                         "thirdPartyUser" => "moki_ruby",
                                         "clientName" => "MokiRuby",
                                         "itemName" => "Profile Name",
                                         "notify" => true,
                                         "payload" => "{abcdef12345-abc-123-ffeea.test}" })
  end
end
