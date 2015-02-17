module DeviceIdentifier
  def self.is_serial?(id)
    (!id.nil? && id.length == 12)
  end

  def self.is_udid?(id)
    !(/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\Z/.match(id)).nil?
  end
end
