require "log"
require "json"
require "uuid"
require "halite"
require "grip"
require "openssl/hmac"

require "./constants"

require "./webex"
require "./webex_web"

require "./webex/**"
require "./webex_web/**"

class Application < Grip::Application
  def initialize(environment : String)
    super(environment: environment, serve_static: false)

    if environment == "development"
      Log.setup(:debug)

      router.insert(0, Grip::Handlers::Log.new)
    end

    pipeline :ws, [
      WebexWeb::Middleware::Authorization.new,
    ]

    scope "/ws" do
      pipe_through :ws

      ws "/messages", WebexWeb::Controllers::MessagesController
    end
  end
end

app = Application.new(Constants::ENVIRONMENT)
app.run
