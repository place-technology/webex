module Webex
  module Models
    module Attachments
      class Item
        include JSON::Serializable
        include JSON::Serializable::Unmapped

        @[JSON::Field(key: "type")]
        property type : String

        @[JSON::Field(key: "text")]
        property text : String

        @[JSON::Field(key: "size")]
        property size : String
      end
    end
  end
end
