require "log"
require "json"
require "uuid"
require "halite"

require "./webex/**"

module Webex
  {% begin %}
    VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify.downcase }}
  {% end %}
end
