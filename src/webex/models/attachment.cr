module Webex
  module Models
    class Attachment
      include JSON::Serializable

      @[JSON::Field(key: "contentType")]
      property content_type : String = "application/vnd.microsoft.card.adaptive"

      @[JSON::Field(key: "content")]
      property content : Card
    end
  end
end
