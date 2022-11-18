module Webex
  module Models
    module Attachments
      class Action
        include JSON::Serializable
        include JSON::Serializable::Unmapped

        @[JSON::Field(key: "type")]
        property type : String = "Column"

        @[JSON::Field(key: "title")]
        property title : String

        @[JSON::Field(key: "data")]
        property data : Hash(String, JSON::Any)
      end
    end
  end
end
