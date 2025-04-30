defmodule OpenMeteo.Behaviour do
  @doc """
  Get the forecast for a given latitude and longitude.

  See: https://open-meteo.com/en/docs
  """
  @callback get_forecast(float(), float()) :: {:ok, Req.Response.t()} | {:error, Exception.t()}
end
