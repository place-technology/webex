module WebexWeb
  module Controllers
    class MessagesController < Grip::Controllers::WebSocket
      property client : Webex::Client
      property registered_sockets : Webex::Synchronized(Hash(String, Array(Socket))) = Webex::Synchronized(Hash(String, Array(Socket))).new

      def initialize
        super

        session = Webex::Session.new(Constants::WEBEX_TEAMS_ACCESS_TOKEN)
        @client = Webex::Client.new(session)

        device = client.device

        socket = HTTP::WebSocket.new(URI.parse(device.websocket_url))

        spawn do
          socket.on_binary do |binary|
            message = String.new(binary)

            event = Webex::Models::Event.from_json(message)

            if event.data.event_type != "status.start_typing" &&
               event.data.event_type != "conversation.highlight"
              message_id = client.message_id(event.data.activity)
              message = client.messages.get(message_id)

              if message.person_id != client.id
                if sockets = registered_sockets[event.data.activity.actor.organization_id]?
                  sockets.each do |registered_socket|
                    registered_socket.send({"event" => event, "message" => message}.to_json)
                  end
                end
              end
            end
          rescue JSON::SerializableError
            # Ignore the JSON::SerializableError
          rescue KeyError
            # Ignore the KeyError
          rescue exception
            Log.error(exception: exception) { "Failed to dispatch a message to the WebSocket" }
          end

          # * Authorization is done through a WebSocket message sent
          # * to the device endpoint.

          message = {
            "id"         => UUID.random.to_s,
            "type"       => "authorization",
            "trackingId" => ["webex", UUID.random.to_s].join("-"),
            "data"       => {
              "token" => ["Bearer", session.access_token].join(" "),
            },
          }

          socket.send(message.to_json)
          socket.run
        end
      end

      def on_open(context : Context, socket : Socket) : Void
        # Executed when a client opens a connection to the server.
        organization_id = context.get_req_header("Organization-ID")

        if sockets = registered_sockets[organization_id]?
          sockets.push(socket)
        else
          registered_sockets[organization_id] = [socket] of Socket
        end
      end

      def on_message(context : Context, socket : Socket, message : String) : Void
        # Executed when a client sends a message.
        message = Webex::Models::Message.from_json(message)
        client.messages.create(message.room_id, message.parent_id, message.to_person_id, message.to_person_email, message.text, message.markdown, message.files, message.attachments)
      end

      def on_ping(context : Context, socket : Socket, message : String) : Void
        # Executed when a client pings the server.
      end

      def on_pong(context : Context, socket : Socket, message : String) : Void
        # Executed when a server receives a pong.
      end

      def on_binary(context : Context, socket : Socket, binary : Bytes) : Void
        # Executed when a client sends a binary message.
      end

      def on_close(context : Context, socket : Socket, close_code : HTTP::WebSocket::CloseCode | Int?, message : String) : Void
        # Executed when a client closes the connection to the server.
        organization_id = context.get_req_header("Organization-ID")

        if sockets = registered_sockets[organization_id]?
          sockets.delete(socket)
        end
      end
    end
  end
end
