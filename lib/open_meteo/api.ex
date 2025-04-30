defmodule OpenMeteo.API do
  @moduledoc """
  Implements the real behaviour of OpenMeteo.
  """
  @behaviour OpenMeteo.Behaviour

  @impl true
  def get_forecast(latitude, longitude, options \\ []) do
    [
      base_url: "https://api.open-meteo.com/v1/forecast",
      # not retrying because we don't have too much information on the API docs.
      retry: false,
      params: [
        latitude: latitude,
        longitude: longitude,
        daily: "temperature_2m_max",
        timezone: "America/Sao_Paulo",
        forecast_days: 6
      ]
    ]
    |> Keyword.merge(options)
    |> Keyword.merge(Application.get_env(:tempex, :weather_req_options, []))
    |> Req.request()
    |> handle_response()
  end

  defp handle_response({:ok, %Req.Response{status: 503}}) do
    {:error, :service_unavailable}
  end

  defp handle_response({:ok, %Req.Response{status: 500}}) do
    {:error, :internal_server_error}
  end

  defp handle_response({:ok, %Req.Response{status: 200, body: body}}) do
    {:ok, body}
  end
end
