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

  describe ".tenant_managed_apps" do
    it "raises an error if no tenant ID is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = ''
      ENV['MOKI_API_KEY'] = 'secret-key'

      expect { MokiRuby.tenant_managed_apps }.to raise_error
    end

    it "raises an error if no API key is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = ''

      expect { MokiRuby.tenant_managed_apps }.to raise_error
    end

    it "retuns an array of IOSProfile objects" do
      load_good_stubs
      data = MokiRuby.tenant_managed_apps
      expect(data.count).to eq(2)
      expect(data.first).to be_kind_of(TenantManagedApp)
      expect(data.first.name).to eq("MokiTouch 2.0")
    end
  end

  describe ".action" do
    it "raises an error if no tenant ID is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = ''
      ENV['MOKI_API_KEY'] = 'secret-key'

      expect { MokiRuby.action }.to raise_error
    end

    it "raises an error if no API key is provided" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = ''

      expect { MokiRuby.action }.to raise_error
    end

    it "retuns an Action object" do
      load_good_stubs
      data = MokiRuby.action("abcd1234-1234-1234-1234-abcdef123456", "b4d71a15­183b­4971­a3bd­d139754a40fe")
      expect(data).to be_kind_of(Action)
      expect(data.id).to eq("b4d71a15­183b­4971­a3bd­d139754a40fe")
    end
  end
end
