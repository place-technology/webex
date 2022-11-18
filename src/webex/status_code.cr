module Webex
  class StatusCode
    getter code : Int32

    def initialize(@code : Int32)
    end

    def valid? : Bool
      case @code
      when 200, 204
        true
      else
        false
      end
    end

    def message : String
      Constants::STATUS_CODES[@code]
    end
  end
end
