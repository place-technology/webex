module Webex
  module Models
    module Attachments
      module Set
        class Action
          include JSON::Serializable
          include JSON::Serializable::Unmapped

          @[JSON::Field(key: "type")]
          property type : String = "ActionSet"

          @[JSON::Field(key: "actions")]
          property actions : Array(Attachments::Action)
        end
      end
    end
  end
end
