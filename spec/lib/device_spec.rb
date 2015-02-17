require 'spec_helper'
require 'device'

describe Device do
  let(:sn) { "ABCDEFGHIJ12" }
  let(:udid) { "abcd1234-1234-1234-1234-abcdef123456" }

  describe 'initialization' do
    context "with serial number" do
      it "is valid" do
        device = Device.new(sn)
        expect(device.id).to eq sn
        expect(device.identifier_type).to eq :serial
      end
    end

    context "with UDID" do
      it "is valid" do
        device = Device.new(udid)
        expect(device.id).to eq udid
      end
    end

    context "with invalid identifier" do
      it "is invalid" do
        expect{ Device.new() }.to raise_error
      end
    end
  end

  describe "#device_id_param" do
    describe "Serial Number" do
      it "prepends serial number data" do
        device = Device.new(sn)
        expect(device.device_id_param).to eq "sn-!-#{ sn }"
      end
    end

    describe "UDID" do
      it "prepends serial number data" do
        device = Device.new(udid)
        expect(device.device_id_param).to eq udid
      end
    end
  end
end
