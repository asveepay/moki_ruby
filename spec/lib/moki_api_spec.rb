require 'spec_helper'
require 'moki_api'

describe MokiAPI do
  describe "missing env variable" do
    it "MOKI_API_URL raises an error" do
      ENV['MOKI_API_URL'] = ''
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = 'secret-key'
      expect { MokiAPI.full_url("/test") }.to raise_error
    end

    it "MOKI_TENANT_ID raises an error" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = ''
      ENV['MOKI_API_KEY'] = 'secret-key'
      expect { MokiAPI.full_url("/test") }.to raise_error
    end

    it "MOKI_API_KEY raises an error" do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = ''
      expect { MokiAPI.issue_request(:get, "/test", {}) }.to raise_error
    end
  end

  describe "with all environment variables set" do
    before do
      ENV['MOKI_API_URL'] = 'http://localhost:9292'
      ENV['MOKI_TENANT_ID'] = 'abcd123-test'
      ENV['MOKI_API_KEY'] = 'secret-key'
    end

    it 'hits the iosprofiles endpoint correctly' do
      expect(MokiAPI).to receive(:issue_request) { |method, url, options|
        expect(method).to eq(:get)
        expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/iosprofiles")
      }.and_return('{}')
      MokiAPI.ios_profiles
    end

    describe "device profile list" do
      it 'hits the endpoint correctly with a UDID' do
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/abcd1234-1234-1234-1234-abcdef123456/profiles")
        }.and_return('{}')
        MokiAPI.device_profile_list("abcd1234-1234-1234-1234-abcdef123456")
      end

      it 'hits the endpoint correctly with a serial number' do
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/sn-!-ABCDEFGHIJ12/profiles")
        }.and_return('{}')
        MokiAPI.device_profile_list("ABCDEFGHIJ12")
      end

      it 'raises an error if not given a serial or udid' do
        expect { MokiAPI.device_profile_list("ermishness-nope") }.to raise_error
      end
    end

    describe "device managed app list" do
      it 'hits the endpoint correctly with a UDID' do
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/abcd1234-1234-1234-1234-abcdef123456/managedapps")
        }.and_return('{}')
        MokiAPI.device_managed_app_list("abcd1234-1234-1234-1234-abcdef123456")
      end

      it 'hits the endpoint correctly with a serial number' do
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/sn-!-ABCDEFGHIJ12/managedapps")
        }.and_return('{}')
        MokiAPI.device_managed_app_list("ABCDEFGHIJ12")
      end

      it 'raises an error if not given a serial or udid' do
        expect { MokiAPI.device_managed_app_list("ermishness-nope") }.to raise_error
      end
    end
  end
end
