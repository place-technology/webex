module Webex
  module Exceptions
    class StatusCode < Exception
      getter code : Int32

      def initialize(message : String, @code : Int32)
        super(message)
      end
    end
  end
end
