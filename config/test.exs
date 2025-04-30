import Config

config :tempex,
  weather_req_options: [
    plug: {Req.Test, OpenMeteo.API}
  ]
