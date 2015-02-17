require "moki_ruby/version"

module MokiRuby
  describe ".iosprofiles" do
    it "raises an error if no tenant ID is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = ''
      ENV['MOKI_API_KEY'] = 'secret-key'

      expect { MokiRuby.iosprofiles }.to raise_error
    end

    it "raises an error if no API key is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = ''

      expect { MokiRuby.iosprofiles }.to raise_error
    end

    xit "retuns an array of IOSProfile objects" do

    end
  end
end
