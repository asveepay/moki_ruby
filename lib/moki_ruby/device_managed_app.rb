class DeviceManagedApp
  attr_accessor :status, :app_identifier, :management_flags

  def self.from_hash(input_hash)
    new_profile = self.new
    new_profile.status = input_hash['Status']
    new_profile.app_identifier = input_hash['appIdentifier']
    new_profile.management_flags = input_hash['ManagementFlags']

    new_profile
  end

  def to_hash
    {
      "Status" => self.status,
      "appIdentifier" => self.app_identifier,
      "ManagementFlags" => self.management_flags
    }
  end
end
