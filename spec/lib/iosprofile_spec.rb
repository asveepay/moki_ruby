require 'spec_helper'
require 'moki_ruby/iosprofile'

describe IOSProfile do
  let(:response_hash) { { "id" => "01234657678-abcd123-test",
                          "lastSeen" => 1413913980475,
                          "name" => "Profile Name",
                          "displayName" => "Profile Display Name",
                          "description" => "Profile Description",
                          "identifier" => "abcdef12345-abc-123-ffeea.test" } }

  let(:attrs) { %w(id lastSeen name displayName description identifier) }

  it "will load from a hash with string keys" do
    profile = IOSProfile.from_hash(response_hash)
    attrs.each do |attribute|
      expect(profile.send(attribute)).to eq(response_hash[attribute])
    end
  end

  it "will convert the response to a hash" do
    profile = IOSProfile.new
    attrs.each do |attribute|
      profile.send("#{ attribute }=", response_hash[attribute])
    end
    expect(profile.to_hash).to eq(response_hash)
  end
end
