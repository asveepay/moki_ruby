class Device
  attr :id

  def initialize(identifier)
    raise "Valid UDID or Serial Number required" unless is_serial?(identifier) || is_udid?(identifier)
    id = identifier
  end

  private

  def is_serial?(id)
    (!id.nil? && id.length == 12)
  end

  def is_udid?(id)
    !(/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\Z/.match(id)).nil?
  end
end
