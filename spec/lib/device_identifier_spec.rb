require 'spec_helper'
require 'moki_ruby/device_identifier'

describe DeviceIdentifier do
  it "picks out a serial number as a 12-character string" do
    expect(DeviceIdentifier.is_serial?("ABC123DEF456")).to eq(true)
    expect(DeviceIdentifier.is_serial?("123456789012")).to eq(true)
    expect(DeviceIdentifier.is_serial?("F55VM3KK9G5F")).to eq(true)
    expect(DeviceIdentifier.is_serial?("ABC123DE56")).to eq(false)
    expect(DeviceIdentifier.is_serial?("123456789012123")).to eq(false)
  end

  it "identifies a UDID" do
    expect(DeviceIdentifier.is_udid?("ABC123DEF456")).to eq(false)
    expect(DeviceIdentifier.is_udid?("abc12345-de12-abd5-7777-abcdefghijkl")).to eq(false)
    expect(DeviceIdentifier.is_udid?("abc12345-de12-abd5-1234-abcdef123456")).to eq(true)
    expect(DeviceIdentifier.is_udid?("abc1235-def125-hjm-erm")).to eq(false)
  end
end
