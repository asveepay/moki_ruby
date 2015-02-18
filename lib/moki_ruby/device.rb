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

    def device_id_param
      if identifier_type == :serial
        "sn-!-#{ id }"
      else
        id
      end
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

      data = MokiAPI.perform_action(device_id_param, install_hash(tenant_managed_app)).value
      Action.from_hash(data.body)
    end

    private

    def install_hash(tenant_managed_app)
      {}.tap do |h|
        h["action"] = "install_app",
        h["thirdPartyUser"] = "itsmebro",
        h["clientName"] = "iPad10",
        h["itemName"] = tenant_managed_app.name,
        h["notify"] = true,
        h["payload"] = {
                       "ManagementFlags" => determine_management_flag(tenant_managed_app),
                       "identifier" => tenant_managed_app.identifier,
                       "iTunesStoreID" => tenant_managed_app.itunes_store_id,
                       "ManifestURL" => tenant_managed_app.manifest_url,
                       "version" => tenant_managed_app.version }
      end
    end

    def determine_management_flag(tenant_managed_app)
      tenant_managed_app.manifest_url ? 1 : 0
    end

    def is_serial?(id)
      (!id.nil? && id.length == 12)
    end

    def is_udid?(id)
      !(/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\Z/.match(id)).nil?
    end
  end
end
