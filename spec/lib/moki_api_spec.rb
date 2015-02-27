require 'spec_helper'
require 'moki_ruby/moki_api'

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

    describe "device details" do
      it 'issues a get request using the device parameter' do
        param = "sn-!-ABCDEFGHIJ12"
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/#{ param }")
        }.and_return('{}')
        MokiAPI.device_details(param)
      end
    end

    describe "device profile list" do
      it 'issues a get request using device parameter' do
        param = "sn-!-ABCDEFGHIJ12"
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/#{ param }/profiles")
        }.and_return('{}')
        MokiAPI.device_profile_list(param)
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
    end

    describe "action" do
      let(:action_id) { "b4d71a15­183b­4971­a3bd­d139754a40fe" }

      it 'hits the endpoint correctly with a Device ID and Action id' do
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:get)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/abcd1234-1234-1234-1234-abcdef123456/actions/#{action_id}")
        }.and_return('{}')
        MokiAPI.action("abcd1234-1234-1234-1234-abcdef123456", "b4d71a15­183b­4971­a3bd­d139754a40fe")
      end
    end

    it 'hits the iosprofiles endpoint correctly' do
      expect(MokiAPI).to receive(:issue_request) { |method, url, options|
        expect(method).to eq(:get)
        expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/iosmanagedapps")
      }.and_return('{}')
      MokiAPI.tenant_managed_app_list
    end

    describe "perform action" do
      it 'performs put request to action endpoint with provided parameters' do
        body_hash = { foo: 'bar' }
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:put)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/devices/abcd1234-1234-1234-1234-abcdef123456/actions")
          expect(options).to eq body_hash
        }.and_return('{}')

        MokiAPI.perform_action('abcd1234-1234-1234-1234-abcdef123456', body_hash)
      end
    end

    describe "pre enroll" do
      it 'performs the post to preenroll with the provided parameters' do
        enroll_hash = { "serialNumber" => "ABCDEFGHIJKL", "clientCode" => "12944", "token" => "c12944-token" }
        expect(MokiAPI).to receive(:issue_request) { |method, url, options|
          expect(method).to eq(:post)
          expect(url).to eq("http://localhost:9292/rest/v1/api/tenants/#{ ENV['MOKI_TENANT_ID'] }/preenroll")
          expect(options).to eq enroll_hash
        }.and_return('{}')

        MokiAPI.pre_enroll(enroll_hash)
      end
    end
  end
end
