# Cisco Webex Client for Crystal Lang

You can use this as the basis for building a Webex Bot

## Installation

Add the dependency to your `shard.yml`:

  ```yaml
    dependencies:
      webex:
        github: place-technology/webex
  ```


## Obtaining a bot access token

You'll need a developers account at cisco and then do the following:

1. ...
2. ...

## Usage

Configure the client:

```crystal

require "webex"

access_token = "ACCESS_TOKEN"

session = Webex::Session.new(access_token: access_token)

client =
  Webex::Client.new(
    name: "Adam",
    session: session,
    emails: [
      "your_email@email.com",
    ] of String,
    commands: [
      Webex::Commands::Echo.new,
    ] of Webex::Command
  )

client.run
```
