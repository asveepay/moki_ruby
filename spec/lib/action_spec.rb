require 'spec_helper'
require 'moki_ruby/action'

describe Action do
  let(:response_hash) {
    { 
      "id" => "b4d71a15­183b­4971­a3bd­d139754a40fe",
      "lastSeen" => 1420583405416,
      "action" => "removeprofile",
      "status" => "completed",
      "clientName" => "Web",
      "itemName" => "Profile Name",
      "thirdPartyUser" => "itsmebro",
      "payload" => "{profile Identifier}",
      "note" => "test"
    }
  }

  it "will load from a hash with string keys" do
    action = Action.from_hash(response_hash)

    expect(action.id).to eq response_hash["id"]
    expect(action.last_seen).to eq response_hash["lastSeen"]
    expect(action.action).to eq response_hash["action"]
    expect(action.status).to eq response_hash["status"]
    expect(action.client_name).to eq response_hash["clientName"]
    expect(action.item_name).to eq response_hash["itemName"]
    expect(action.third_party_user).to eq response_hash["thirdPartyUser"]
    expect(action.payload).to eq response_hash["payload"]
    expect(action.note).to eq response_hash["note"]
  end

  it "will convert the response to a hash" do
    action = Action.new

    action.id = response_hash["id"]
    action.last_seen = response_hash["lastSeen"]
    action.action = response_hash["action"]
    action.status = response_hash["status"]
    action.client_name = response_hash["clientName"]
    action.item_name = response_hash["itemName"]
    action.third_party_user = response_hash["thirdPartyUser"]
    action.payload = response_hash["payload"]
    action.note = response_hash["note"]

    expect(action.to_hash).to eq(response_hash)
  end
end
