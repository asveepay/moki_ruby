module MokiRuby
  class DeviceManagedApp
    attr_accessor :status, :app_identifier, :management_flags

    def self.from_hash(input_hash)
      new_app = self.new
      new_app.status = input_hash['Status']
      new_app.app_identifier = input_hash['appIdentifier']
      new_app.management_flags = input_hash['ManagementFlags']

      new_app
    end

    def to_hash
      {
        "Status" => self.status,
        "appIdentifier" => self.app_identifier,
        "ManagementFlags" => self.management_flags
      }
    end

    def uninstall_hash
      {
        "action" => "remove_app",
        "thirdPartyUser" => "moki_ruby",
        "clientName" => "MokiRuby",
        "itemName" => "iOS App",
        "notify" => true,
        "payload" => self.app_identifier
      }
    end
  end
end
