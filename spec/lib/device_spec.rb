require 'spec_helper'
require 'moki_ruby/device'

describe MokiRuby::Device do
  let(:sn) { "ABCDEFGHIJ12" }
  let(:udid) { "abcd1234-1234-1234-1234-abcdef123456" }
  let(:device) { MokiRuby::Device.new(udid) }
  let(:serial_device) { MokiRuby::Device.new(sn) }

  describe 'initialization' do
    context "with serial number" do
      it "is valid" do
        expect(serial_device.id).to eq sn
        expect(serial_device.identifier_type).to eq :serial
      end
    end

    context "with UDID" do
      it "is valid" do
        expect(device.id).to eq udid
      end
    end

    context "with invalid identifier" do
      it "is invalid" do
        expect{ MokiRuby::Device.new() }.to raise_error
      end
    end
  end

  describe "#device_id_param" do
    describe "Serial Number" do
      it "prepends serial number data" do
        expect(serial_device.device_id_param).to eq "sn-!-#{ sn }"
      end
    end

    describe "UDID" do
      it "prepends serial number data" do
        expect(device.device_id_param).to eq udid
      end
    end
  end

  describe "#profiles" do
    it "calls MokiAPI.device_profile_list with correct params" do
      expect(MokiAPI).to receive_message_chain(:device_profile_list, :value).and_return(Hashie::Mash.new({ body: [] }))
      device.profiles
    end

    it "returns an array of device profiles" do
      load_good_stubs
      profiles = device.profiles
      expect(profiles.map { |p| p.class }.uniq).to eq [DeviceIOSProfile]
    end

    it "returns nil if the device can not be found" do
      load_bad_stubs
      expect(device.profiles).to be_nil
    end
  end

  describe "#add_profile" do
    it "requires a TenantIOSProfile" do
      expect { device.add_profile('erm') }.to raise_error
    end

    it "calls MokiAPI.perform with the profile's install parameters" do
      load_good_stubs

      iosprofile = TenantIOSProfile.from_hash(@iosprofiles_stub_response.first)

      expect(MokiAPI).to receive(:perform_action).with(udid, iosprofile.install_hash)
                                                 .and_return(Hashie::Mash.new(value: { body: @action_stub_response }))

      device.add_profile(iosprofile)
    end

    it "returns nil if the device was not found" do
      load_bad_stubs
      iosprofile = TenantIOSProfile.from_hash(@iosprofiles_stub_response.first)
      expect(device.add_profile(iosprofile)).to be_nil
    end
  end

  describe "#remove_profile" do
    it "requires an DeviceIOSProfile" do
      expect { device.remove_profile('erm') }.to raise_error
    end

    it "calls MokiAPI.perform with the profile's install parameters" do
      load_good_stubs

      iosprofile = DeviceIOSProfile.from_hash(@device_iosprofiles_stub_response.first)

      expect(MokiAPI).to receive(:perform_action).with(udid, iosprofile.removal_hash)
                                                 .and_return(Hashie::Mash.new(value: { body: @action_stub_response }))

      device.remove_profile(iosprofile)
    end

    it "returns nil if the device was not found" do
      load_bad_stubs
      iosprofile = TenantIOSProfile.from_hash(@iosprofiles_stub_response.first)
      expect(device.add_profile(iosprofile)).to be_nil
    end
  end

  describe "#install_app" do
    it "requires a TenantManagedApp" do
      expect { device.install_app('foo') }.to raise_error
    end

    it "calls MokiAPI.perform with store app parameters" do
      load_good_stubs

      tenant_managed_app = TenantManagedApp.from_hash({ "name" => "MokiTouch 2.0",
                                                        "identifier" => "com.mokimobility.mokitouch2",
                                                        "version" => "1.1.1",
                                                        "ManagementFlags" => 0,
                                                        "ManifestURL" => "some url" })

      expect(MokiAPI).to receive(:perform_action).with(udid, tenant_managed_app.install_hash)
                                                 .and_return(Hashie::Mash.new(value: { body: @action_stub_response }))
      device.install_app(tenant_managed_app)
    end

    it "returns nil if the device was not found" do
      load_bad_stubs
      expect(device.install_app(TenantManagedApp.new)).to be_nil
    end
  end

  describe "#managed_apps" do
    it "calls MokiAPI.device_managed_app_list" do
      response = []
      expect(MokiAPI).to receive_message_chain(:device_managed_app_list, :value).and_return(Hashie::Mash.new({ body: response, status: 200, headers: {} }))
      device.managed_apps
    end

    it "returns an array of managed_apps" do
      load_good_stubs
      apps = device.managed_apps
      expect(apps.map { |app| app.class }.uniq).to eq [DeviceManagedApp]
    end

    it "returns nil if the device was not found" do
      load_bad_stubs
      expect(device.managed_apps).to be_nil
    end
  end

  describe "#get_action" do
    let(:action_id) { "b4d71a15­183b­4971­a3bd­d139754a40fe" }

    it "calls MokiAPI.action" do
      expect(MokiAPI).to receive_message_chain(:action, :value).and_return(Hashie::Mash.new({ body: {}, status: 200, headers: {} }))
      device.get_action(action_id)
    end

    it "returns an Action object" do
      load_good_stubs
      action = device.get_action(action_id)
      expect(action).to be_kind_of(Action)
    end

    it "returns nil if the device was not found" do
      load_bad_stubs
      expect(device.get_action(action_id)).to be_nil
    end
  end

  describe "#pre_enroll" do
    it "sends the serial number number along with the specific client id and token" do
      device = MokiRuby::Device.new(sn)
      device.client_id = 12944
      device.token = "c12944-token"

      expected_hash = { "clientCode" => "12944",
                        "serialNumber" => sn,
                        "token" => "c12944-token" }

      expect(MokiAPI).to receive(:pre_enroll).with(expected_hash)
                                             .and_return(Hashie::Mash.new(value: { body: @action_stub_response }))
      device.pre_enroll
    end

    it "will error if does not have a serial number" do
      expect {device.pre_enroll}.to raise_error
    end

    it "will send blank values for client ID and token if both are missing" do
      device = MokiRuby::Device.new(sn)
      expect(MokiAPI).to receive(:pre_enroll).with({ "clientCode" => nil, "serialNumber" => sn, "token" => nil })
                                             .and_return(Hashie::Mash.new(value: { body: nil }))
      device.pre_enroll
    end

    it "will send blank values for both client ID and token if client id is missing" do
      device = MokiRuby::Device.new(sn)
      device.token = "who cares"
      expect(MokiAPI).to receive(:pre_enroll).with({ "clientCode" => nil, "serialNumber" => sn, "token" => nil })
                                             .and_return(Hashie::Mash.new(value: { body: nil }))
      device.pre_enroll
    end

    it "will send blank values for both client ID and token if token is missing" do
      device = MokiRuby::Device.new(sn)
      device.client_id = "who cares"
      expect(MokiAPI).to receive(:pre_enroll).with({ "clientCode" => nil, "serialNumber" => sn, "token" => nil })
                                             .and_return(Hashie::Mash.new(value: { body: nil }))
      device.pre_enroll
    end

    it "will return true if enrollment is successful" do
      device = MokiRuby::Device.new(sn)
      allow(MokiAPI).to receive_message_chain(:pre_enroll, :value).
                     and_return(Hashie::Mash.new({ body: {}, status: 200, headers: {} }))

      expect(device.pre_enroll).to be true
    end

    it "will return nil if enrollment is not successful" do
      device = MokiRuby::Device.new(sn)
      allow(MokiAPI).to receive_message_chain(:pre_enroll, :value).
                     and_return(Hashie::Mash.new({ body: {}, status: 500, headers: {} }))

      expect(device.pre_enroll).to be_nil
    end
  end
end
