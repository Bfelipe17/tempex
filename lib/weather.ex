defmodule Weather do
  @api "http://api.openweathermap.org/data/2.5/weather?q="

  def get_appid() do
    System.get_env("API_KEY")
  end

  def get_endpoint(location) do
    location = URI.encode(location)

    "#{@api}#{location}&appid=#{get_appid()}"
  end

  def kelvin_to_celsius(kelvin) do
    (kelvin - 273.15) |> Float.round(1)
  end

  def temperature_of(location) do
    result = get_endpoint(location) |> HTTPoison.get() |> parse_response()

    case result do
      {:ok, temp} -> "#{location}: #{temp} ºC"
      :error -> "#{location} not found"
    end
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |> JSON.decode!()
    |> compute_temperature()
  end

  defp parse_response(_), do: :error

  defp compute_temperature(%{"main" => %{"temp" => temp}}) do
    try do
      temp |> kelvin_to_celsius()

      {:ok, temp}
    rescue
      _ -> :error
    end
  end
end
