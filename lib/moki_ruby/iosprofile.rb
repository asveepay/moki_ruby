class IOSProfile
  attr_accessor :id, :lastSeen, :name, :displayName, :description, :identifier

  def self.from_hash(input_hash)
    new_profile = self.new
    %w(id lastSeen name displayName description identifier).each do |attr|
      new_profile.send("#{ attr }=", input_hash[attr])
    end

    new_profile
  end

  def to_hash
    {}.tap do |hash|
      self.instance_variables.each do |var|
        hash[var.to_s.delete("@")] = instance_variable_get(var)
      end
    end
  end
end
