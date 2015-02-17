require 'spec_helper'
require 'support/common_stubs'

describe MokiRuby do
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

    it "retuns an array of IOSProfile objects" do
      load_good_stubs
      data = MokiRuby.ios_profiles
      expect(data.count).to eq(4)
      expect(data.first).to be_kind_of(IOSProfile)
      expect(data.first.name).to eq("Test Profile 1")
    end
  end

  describe ".device_profiles" do
    it "raises an error if no tenant ID is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = ''
      ENV['MOKI_API_KEY'] = 'secret-key'

      expect { MokiRuby.device_profiles('ABC123DEF456') }.to raise_error
    end

    it "raises an error if no API key is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = ''

      expect { MokiRuby.device_profiles('ABC123DEF456') }.to raise_error
    end

    it "raises an error if the device id is bad" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = 'secret-key'

      expect(MokiAPI).to_not receive(:issue_request)
      expect { MokiRuby.device_profiles('BADSERIAL') }.to raise_error
    end

    it "retuns an array of IOSProfile objects" do
      load_good_stubs
      data = MokiRuby.ios_profiles
      expect(data.count).to eq(4)
      expect(data.first).to be_kind_of(IOSProfile)
      expect(data.first.name).to eq("Test Profile 1")
    end
  end
end
