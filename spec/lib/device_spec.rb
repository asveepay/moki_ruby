require 'spec_helper'
require 'moki_ruby/device'

describe MokiRuby::Device do
  let(:sn) { "ABCDEFGHIJ12" }
  let(:udid) { "abcd1234-1234-1234-1234-abcdef123456" }
  let(:device) { MokiRuby::Device.new(udid) }

  describe 'initialization' do
    context "with serial number" do
      it "is valid" do
        device = MokiRuby::Device.new(sn)
        expect(device.id).to eq sn
        expect(device.identifier_type).to eq :serial
      end
    end

    context "with UDID" do
      it "is valid" do
        device = MokiRuby::Device.new(udid)
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
        device = MokiRuby::Device.new(sn)
        expect(device.device_id_param).to eq "sn-!-#{ sn }"
      end
    end

    describe "UDID" do
      it "prepends serial number data" do
        device = MokiRuby::Device.new(udid)
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
      expect(profiles.map { |p| p.class }.uniq).to eq [IOSProfile]
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
  end
end
