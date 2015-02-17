module MokiRuby
  class Device
    attr :id, :identifier_type

    def initialize(identifier)
      if is_serial?(identifier)
        @identifier_type = :serial
      elsif is_udid?(identifier)
        @identifier_type = :udid
      else
        raise "Valid UDID or Serial Number required"
      end
      @id = identifier
    end

    def device_id_param
      if identifier_type == :serial
        "sn-!-#{ id }"
      else
        id
      end
    end

    def profiles
      MokiAPI.device_profile_list(device_id_param)
    end

    def install_app
      params = body_hash.merge({ "action" => 'install_app' })
      # Not sure how Management Flag is determined
      params["payload"]["ManagementFlags"] = 1

      data = MokiAPI.perform_action(device_id_param, params).value
      Action.from_hash(data.body)
    end

    private

    def body_hash
      {
        "thirdPartyUser" => "itsmebro",
        "clientName" => "Some Client Name",
        "itemName" => "MokiTouch2.0",
        "notify" => true,
        "payload" => { "identifier" => "com.mokimobility.mokitouch2",
                       "version" => "1.1.1" }
      }
    end

    def is_serial?(id)
      (!id.nil? && id.length == 12)
    end

    def is_udid?(id)
      !(/\A[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}\Z/.match(id)).nil?
    end
  end
end
