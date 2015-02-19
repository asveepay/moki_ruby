module MokiRuby
  class Action
    attr_accessor :id, :last_seen, :action, :status, :client_name, :item_name, :third_party_user, :payload, :note

    def self.from_hash(input_hash)
      new_action = self.new

      new_action.id = input_hash["id"]
      new_action.last_seen = input_hash["lastSeen"]
      new_action.action = input_hash["action"]
      new_action.status = input_hash["status"]
      new_action.client_name = input_hash["clientName"]
      new_action.item_name = input_hash["itemName"]
      new_action.third_party_user = input_hash["thirdPartyUser"]
      new_action.payload = input_hash["payload"]
      new_action.note = input_hash["note"]

      new_action
    end

    def to_hash
      {
        "id" => self.id,
        "lastSeen" => self.last_seen,
        "action" => self.action,
        "status" => self.status,
        "clientName" => self.client_name,
        "itemName" => self.item_name,
        "thirdPartyUser" => self.third_party_user,
        "payload" => self.payload,
        "note" => self.note
      }
    end
  end
end
