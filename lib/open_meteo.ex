defmodule OpenMeteo do
  @moduledoc """
  This is the interface for OpenMeteo, a weather API.

  Official website:
  https://open-meteo.com/

  Documentation:
  https://open-meteo.com/en/docs
  """
  @behaviour OpenMeteo.Behaviour

  @impl true
  defdelegate get_forecast(latitude, longitude, options \\ []), to: OpenMeteo.API
end
