module Webex
  module Models
    class Card
      include JSON::Serializable

      @[JSON::Field(key: "type")]
      property type : String = "AdaptiveCard"

      @[JSON::Field(key: "$schema")]
      property schema : String = "http://adaptivecards.io/schemas/adaptive-card.json"

      @[JSON::Field(key: "version")]
      property version : String = "1.2"

      @[JSON::Field(key: "body")]
      property body : Array(Attachments::Generic)
    end
  end
end
