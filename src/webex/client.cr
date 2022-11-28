module Webex
  class Client
    Log = ::Log.for(self)

    property id : String

    def initialize(@session : Session)
      @rooms = Api::Rooms.new(@session)
      @people = Api::People.new(@session)
      @messages = Api::Messages.new(@session)

      @id = @people.me.id
    end

    def rooms
      @rooms
    end

    def people
      @people
    end

    def messages
      @messages
    end

    def device(check_existing : Bool = true) : Models::Device
      begin
        if check_existing
          response = @session.get([Constants::DEFAULT_DEVICE_URL, "/", "devices"].join(""))
          data = JSON.parse(response.body)

          devices = data.["devices"].as_a.map do |item|
            Models::Device.from_json(item.to_json)
          end

          devices.each do |device|
            if device.name == nil
              next
            end

            if device.name == Constants::DEVICE["name"]
              return device
            end
          end
        end
      rescue exception : Exceptions::StatusCode
        raise exception if exception.code != 404
      end

      response = @session.post([Constants::DEFAULT_DEVICE_URL, "/", "devices"].join(""), json: Constants::DEVICE)
      device = Models::Device.from_json(response.body)

      Log.debug { "Registered a device: #{device.name} at #{device.websocket_url}" }

      device
    end

    def message_id(activity) : String
      # In order to geo-locate the correct DC to fetch the message from, you need to use the base64 Id of the message.
      id = activity.id
      target_url = activity.target.url
      target_id = activity.target.id

      verb = activity.verb == "post" ? "messages" : "attachment/actions"

      message_url = target_url.gsub(["conversations", "/", target_id].join(""), [verb, "/", id].join(""))
      response = Halite.get(message_url, headers: {"Authorization" => ["Bearer", @session.access_token].join(" ")})

      message = JSON.parse(response.body)

      Log.debug { "Fetched a message id: #{message["id"]}" }

      message["id"].to_s
    end
  end
end
