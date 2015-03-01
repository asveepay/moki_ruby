module MokiRuby
  class Device
    attr_accessor :client_id, :token
    attr_reader :nickname, :title, :last_seen, :checked_out
    attr :id, :identifier_type

    def initialize(identifier)
      if is_serial?(identifier)
        @identifier_type = :serial
      elsif is_udid?(identifier)
        @identifier_type = :udid
      else
        raise "Valid UDID or Serial Number required"
      end
      @id = identifier
    end

    def load_details
      data = MokiAPI.device_details(device_id_param).value
      return nil unless data.status == 200

      @nickname = data.body["nickname"]
      @title = data.body["title"]
      @last_seen = Time.at(data.body["lastSeen"]/1000)
      @checked_out = data.body["checkedOut"]

      return self
    end

    def profiles
      data = MokiAPI.device_profile_list(device_id_param).value
      return nil unless data.status == 200

      data.body.map { |profile| DeviceIOSProfile.from_hash(profile) }
    end

    def managed_apps
      data = MokiAPI.device_managed_app_list(device_id_param).value
      return nil unless data.status == 200

      data.body.map { |app| DeviceManagedApp.from_hash(app) }
    end

    def install_app(tenant_managed_app)
      raise "Tenant Managed App required" unless tenant_managed_app && tenant_managed_app.kind_of?(TenantManagedApp)

      data = MokiAPI.perform_action(device_id_param, tenant_managed_app.install_hash).value
      return nil unless data.status == 200

      Action.from_hash(data.body)
    end

    def add_profile(profile)
      raise "TenantIOSProfile required" unless profile && profile.is_a?(TenantIOSProfile)

      data = MokiAPI.perform_action(device_id_param, profile.install_hash).value
      return nil unless data.status == 200

      Action.from_hash(data.body)
    end

    def remove_profile(profile)
      raise "DeviceIOSProfile required" unless profile && profile.is_a?(DeviceIOSProfile)

      data = MokiAPI.perform_action(device_id_param, profile.removal_hash).value
      return nil unless data.status == 200

      Action.from_hash(data.body)
    end

    def get_action(action_id)
      data = MokiAPI.action(device_id_param, action_id).value
      return nil unless data.status == 200

      Action.from_hash(data.body)
    end

    def pre_enroll
      data = MokiAPI.pre_enroll([enroll_hash]).value

      if data.status == 200
        return true
      else
        return nil
      end
    end

    def device_id_param
      if identifier_type == :serial
        "sn-!-#{ id }"
      else
        id
      end
    end

  private

    def is_serial?(id)
      (!id.nil? && id.length == 12)
    end

    def is_udid?(id)
      !(/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\Z/.match(id)).nil?
    end

    def enroll_hash
      raise "Need Serial Number on Device for Enrollment" unless ((identifier_type == :serial) && !id.nil?)

      hash = { "serialNumber" => id,
               "clientCode" => nil,
               "token" => nil }

      unless token.nil? || token == "" || client_id.nil? || client_id == ""
        hash = hash.merge({ "clientCode" => client_id.to_s,
                            "token" => token })
      end

      return hash
    end
  end
end
