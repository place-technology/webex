module WebexWeb
  module Middleware
    class Authorization
      include HTTP::Handler

      def call(context : HTTP::Server::Context) : HTTP::Server::Context
        organization_id = context.get_req_header("Organization-ID")
        api_key = context.get_req_header("X-API-Key")

        unless OpenSSL::HMAC.hexdigest(:sha512, Constants::SECRET, organization_id) == api_key
          raise Exception.new("This endpoint requires an `X-API-Key` header, you either did not supply it or supplied the incorrect one.")
        end

        context
      rescue exception
        raise Grip::Exceptions::Unauthorized.new
      end
    end
  end
end
