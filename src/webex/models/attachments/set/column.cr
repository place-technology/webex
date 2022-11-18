module Webex
  module Models
    module Attachments
      module Set
        class Column
          include JSON::Serializable
          include JSON::Serializable::Unmapped

          @[JSON::Field(key: "type")]
          property type : String = "ColumnSet"

          @[JSON::Field(key: "columns")]
          property columns : Array(Attachments::Column)
        end
      end
    end
  end
end
