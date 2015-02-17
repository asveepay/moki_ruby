require 'spec_helper'
require 'device'

describe Device do
  let(:sn) { "ABCDEFGHIJ12" }
  let(:udid) { "abcd1234-1234-1234-1234-abcdef123456" }

  describe 'initialization' do
    context "with serial number" do
      it "is valid" do
        expect{ Device.new(sn) }.not_to raise_error
      end
    end

    context "with UDID" do
      it "is valid" do
        expect{ Device.new(udid) }.not_to raise_error
      end
    end

    context "with invalid identifier" do
      it "is invalid" do
        expect{ Device.new() }.to raise_error
      end
    end
  end
end
