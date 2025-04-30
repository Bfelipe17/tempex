Mox.defmock(OpenMeteoMock, for: OpenMeteo.Behaviour)
Application.put_env(:tempex, :open_meteo_impl, OpenMeteoMock)

ExUnit.start()
