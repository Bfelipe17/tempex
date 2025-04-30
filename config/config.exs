import Config

config :tempex, weather_req_options: []

config :tempex, open_meteo_impl: OpenMeteo.API

import_config "#{Mix.env()}.exs"
