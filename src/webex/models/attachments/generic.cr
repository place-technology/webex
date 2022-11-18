module Webex
  module Models
    module Attachments
      class Generic
        include JSON::Serializable
        include JSON::Serializable::Unmapped
      end
    end
  end
end
