defmodule Weather do
  @api "http://api.openweathermap.org/data/2.5/weather?q="

  def start(cities) do
    manager_pid = spawn(__MODULE__, :manager, [[], Enum.count(cities)])

    cities
    |> Enum.map(fn city ->
      pid = spawn(__MODULE__, :get_temperature, [])
      send(pid, {manager_pid, city})
    end)
  end

  def manager(cities \\ [], total) do
    receive do
      {:ok, temp} ->
        results = [temp | cities]

        if(Enum.count(results) == total) do
          send(self(), :exit)
        end

        manager(results, total)

      :exit ->
        IO.puts(cities |> Enum.sort() |> Enum.join(", "))

      _ ->
        manager(cities, total)
    end
  end

  def get_temperature() do
    receive do
      {manager_pid, location} ->
        send(manager_pid, {:ok, temperature_of(location)})

      _ ->
        IO.puts("Error")
    end

    get_temperature()
  end

  def display_city(city) do
    IO.inspect(city)
  end

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
      temp = kelvin_to_celsius(temp)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end
end
