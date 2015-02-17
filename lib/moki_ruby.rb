require "moki_ruby/version"

module MokiRuby
  def self.ios_profiles
    data = MokiAPI.ios_profiles.value
    data.body.map { |profile| IOSProfile.from_hash(profile) }
  end
end
