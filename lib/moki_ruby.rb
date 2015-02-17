require "moki_ruby/version"

module MokiRuby
  def self.action(device_id, action_id)
    data = MokiAPI.action(device_id, action_id).value
    Action.from_hash(data.body)
  end

  def self.ios_profiles
    data = MokiAPI.ios_profiles.value
    data.body.map { |profile| IOSProfile.from_hash(profile) }
  end

  def self.device_profiles(device_id)
    data = MokiAPI.device_profile_list(device_id).value
    data.body.map { |profile| IOSProfile.from_hash(profile) }
  end

  def self.tenant_managed_apps
    data = MokiAPI.tenant_managed_app_list.value
    data.body.map { |profile| TenantManagedApp.from_hash(profile) }
  end

  def self.device_managed_apps(device_id)
    data = MokiAPI.device_managed_app_list(device_id).value
    data.body.map { |app| DeviceManagedApp.from_hash(app) }
  end
end
