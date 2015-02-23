def load_base_stubs
  @iosprofiles_stub_response = [{"id"=>"093b57ba-face-0100-4321-abcdef123456", "lastSeen"=>1413913980475, "name"=>"Test Profile 1", "displayName"=>"Test Profile 1", "description"=>"Test Profile 1", "identifier"=>"com.belly.a9a4129f-other01.TestProfile1"},
                                {"id"=>"4023fb77-face-0200-4321-abcdef123456", "lastSeen"=>1423528420218, "name"=>"Custom Profile", "displayName"=>"Custom Profile", "description"=>"Custom Profile", "identifier"=>nil},
                                {"id"=>"462d3468-face-0300-4321-abcdef123456", "lastSeen"=>1415637997309, "name"=>"Test Profile 3", "displayName"=>"Test Profile 3", "description"=>"Test Profile 3", "identifier"=>"com.belly.1e968fa0-other03.TestProfile3"},
                                {"id"=>"fcd2bfb0-face-0400-4321-abcdef123456", "lastSeen"=>1423524426266, "name"=>"Test Profile 4", "displayName"=>"Test Profile 4", "description"=>"Test Profile 4", "identifier"=>"com.belly.1e968fa0-other04.TestProfile4"}]

  @device_managed_app_stub_response = [{ "Status" => "Managed", "appIdentifier" => "com.belly.moki.gem.enterprise", "ManagementFlags" => 1 },
                                       { "Status" => "Managed", "appIdentifier" => "com.belly.flop.html.enterprise", "ManagementFlags" => 0 }]

  @tenant_managed_app_stub_response = [{ "id" => "30dedb70­62a9­41b8­b5f0­c960d7d8f79a", "lastSeen" => 1384278494336, "name" => "MokiTouch 2.0", "identifier" => "com.mokimobility.mokitouch2", "version" => "1.1.1", "ManagementFlags" => 0, "iTunesStoreID" => "733151730" },
                                       { "id" => "30dedb71­62b9­41b8­b5f0­c960d7d8f79a", "lastSeen" => 1423524426266, "name" => "Belly Merchant App", "identifier" => "com.belly.flop.html.enterprise", "version" => "3.0", "ManagementFlags" => 1, "ManifestURL" => "https://www.bellycard.com/" }]

  @action_stub_response = { "id" => "b4d71a15­183b­4971­a3bd­d139754a40fe", "lastSeen" => 1420583405416,
                            "action" => "removeprofile", "status" => "completed", "clientName" => "Web", "itemName" => "Profile Name",
                            "thirdPartyUser" => "itsmebro", "payload" => "{profile Identifier}", "note" => "test" }

  @device_iosprofiles_stub_response =
    [
      {
        "PayloadDisplayName" => "Belly Wifi",
        "PayloadVersion" => "1",
        "PayloadRemovalDisallowed" => "false",
        "PayloadIdentifier" => "openvpn-client.openvpn.bellycard.com.033ABCDE-1234-5678-9AAA-C134AAAAAAAA",
        "PayloadContent" => [
          {
            "PayloadDisplayName" => "WiFi",
            "PayloadVersion" => "1",
            "PayloadIdentifier" => "openvpn-client.openvpn.bellycard.com.033ABCDE-1234-5678-9AAA-C134AAAAAAAA.com.apple.wifi.managed.099999EE-ABCD-EF12-3456-7890ABCDEF99",
            "PayloadDescription" => "Configures Wi-Fi settings",
            "PayloadType" => "com.apple.wifi.managed"
          }
        ]
      },
      {
        "PayloadDisplayName" => "Belly MDM Installation",
        "PayloadVersion" => "1",
        "PayloadOrganization" => "Belly Inc",
        "PayloadRemovalDisallowed" => "false",
        "PayloadDescription" => "Allow Belly Inc to track this device, including all apps.",
        "PayloadIdentifier" => "com.belly.mdm",
        "PayloadContent" => [
          {
            "PayloadDisplayName" => "Belly",
            "PayloadVersion" => "1",
            "PayloadOrganization" => "Belly Inc",
            "PayloadIdentifier" => "com.belly.mdm.com.apple.security.pkcs12.00110334-abcd-efab-cdef-123412341234",
            "PayloadDescription" => "Identifies the device to the MDM server using SSL client certificates",
            "PayloadType" => "com.apple.security.pkcs12"
          },
          {
            "PayloadDisplayName" => "Mobile Device Management",
            "PayloadVersion" => "1",
            "PayloadOrganization" => "Belly Inc",
            "PayloadIdentifier" => "com.belly.mdm.com.apple.mdm.1a2b3c4d-5e6f-7a8b-9c0d-0987654321ba",
            "PayloadDescription" => "Configuration for MDM",
            "PayloadType" => "com.apple.mdm"
          }
        ]
      },
      {
        "PayloadDisplayName" => "Belly",
        "PayloadVersion" => "1",
        "PayloadRemovalDisallowed" => "false",
        "PayloadDescription" => "Configurator generated profile for supervised devices",
        "PayloadIdentifier" => "com.apple.configurator.chaperoneprofile",
        "PayloadContent" => [
          {
            "PayloadDisplayName" => "Belly",
            "PayloadVersion" => "1",
            "PayloadIdentifier" => "com.apple.configurator.chaperoneprofile.com.apple.security.root.00ABCD00-3456-9876-DEF0-ABABAB090909",
            "PayloadDescription" => "Configures certificate settings.",
            "PayloadType" => "com.apple.security.root"
          }
        ]
      }
    ]
end

def load_good_stubs
  load_base_stubs

  allow(MokiAPI).to receive_message_chain(:ios_profiles, :value).
                 and_return(Hashie::Mash.new({ body: @iosprofiles_stub_response,
                                               status: 200,
                                               headers: {}}))

  allow(MokiAPI).to receive_message_chain(:device_profile_list, :value).
                 and_return(Hashie::Mash.new({ body: @iosprofiles_stub_response,
                                               status: 200,
                                               headers: {}}))

  allow(MokiAPI).to receive_message_chain(:device_managed_app_list, :value).
                 and_return(Hashie::Mash.new({ body: @device_managed_app_stub_response,
                                               status: 200,
                                               headers: {}}))

  allow(MokiAPI).to receive_message_chain(:tenant_managed_app_list, :value).
                 and_return(Hashie::Mash.new({ body: @tenant_managed_app_stub_response,
                                               status: 200,
                                               headers: {}}))

  allow(MokiAPI).to receive_message_chain(:action, :value).
                 and_return(Hashie::Mash.new({ body: @action_stub_response,
                                               status: 200,
                                               headers: {}}))
end

def load_bad_stubs
  load_base_stubs

  allow(MokiAPI).to receive_message_chain(:device_profile_list, :value).
                 and_return(Hashie::Mash.new({ body: { msg: "Device Not Found", status: 404 },
                                               status: 404,
                                               headers: {}}))
  allow(MokiAPI).to receive_message_chain(:device_managed_app_list, :value).
                 and_return(Hashie::Mash.new({ body: { msg: "Device Not Found", status: 404 },
                                               status: 404,
                                               headers: {}}))
  allow(MokiAPI).to receive_message_chain(:action, :value).
                 and_return(Hashie::Mash.new({ body: { msg: "Device Not Found", status: 404 },
                                               status: 404,
                                               headers: {}}))
  allow(MokiAPI).to receive_message_chain(:perform_action, :value).
                 and_return(Hashie::Mash.new({ body: { msg: "Device Not Found", status: 404 },
                                               status: 404,
                                               headers: {}}))
end
