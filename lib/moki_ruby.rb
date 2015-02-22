require 'require_all'
require_rel "./"

module MokiRuby
  def self.ios_profiles
    data = MokiAPI.ios_profiles.value
    data.body.map { |profile| TenantIOSProfile.from_hash(profile) }
  end

  def self.tenant_managed_apps
    data = MokiAPI.tenant_managed_app_list.value
    data.body.map { |profile| TenantManagedApp.from_hash(profile) }
  end
end
