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
      expect(MokiAPI).to receive(:device_profile_list).with(udid)
      device.profiles
    end
  end

  describe "#install_app" do
    describe "store app" do
      it "calls MokiApi.perform with store app parameters" do

        params = { "action" => "install_app",
                   "thirdPartyUser" =>  "itsmebro",
                   "clientName" =>  "Some Client Name",
                   "itemName"  =>  "MokiTouch2.0",
                   "notify" =>  true,
                   "payload" =>  { "ManagementFlags" => 1,
                                   "identifier" => "com.mokimobility.mokitouch2",
                                   "version" => "1.1.1" } }

        expect(MokiAPI).to receive(:perform_action).with(device.device_id_param, params)
        device.install_app
      end
    end

    describe "enterprise app" do
      it "calls MokiApi.perform with enterprise app parameters" do
      end
    end
  end
end
