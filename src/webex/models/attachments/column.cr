module Webex
  module Models
    module Attachments
      class Column
        include JSON::Serializable
        include JSON::Serializable::Unmapped

        @[JSON::Field(key: "type")]
        property type : String = "Column"

        @[JSON::Field(key: "width")]
        property width : String | Int32

        @[JSON::Field(key: "items")]
        property items : Array(Item)
      end
    end
  end
end
