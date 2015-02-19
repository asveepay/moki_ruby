module MokiRuby
  class Device
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

    def profiles
      data = MokiAPI.device_profile_list(device_id_param).value
      data.body.map { |profile| IOSProfile.from_hash(profile) }
    end

    def managed_apps
      data = MokiAPI.device_managed_app_list(device_id_param).value
      data.body.map { |app| DeviceManagedApp.from_hash(app) }
    end

    def install_app(tenant_managed_app)
      raise "Tenant Managed App required" unless tenant_managed_app && tenant_managed_app.kind_of?(TenantManagedApp)

      data = MokiAPI.perform_action(device_id_param, tenant_managed_app.install_hash).value
      Action.from_hash(data.body)
    end

    def add_profile(profile)
      raise "IOSProfile required" unless profile && profile.is_a?(IOSProfile)

      data = MokiAPI.perform_action(device_id_param, profile.install_hash).value
      Action.from_hash(data.body)
    end

    def remove_profile(profile)
      raise "IOSProfile required" unless profile && profile.is_a?(IOSProfile)

      data = MokiAPI.perform_action(device_id_param, profile.removal_hash).value
      Action.from_hash(data.body)
    end

    def get_action(action_id)
      data = MokiAPI.action(device_id_param, action_id).value
      Action.from_hash(data.body)
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
  end
end
