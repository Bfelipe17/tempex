defmodule Tempex.Forecast do
  @moduledoc """
  This module provides functions to get the forecast for a city.
  It fetches temperature data concurrently for multiple cities and calculates their mean temperatures.
  """

  @type city :: String.t()
  @type coordinates :: %{latitude: float(), longitude: float()}
  @type temperature :: String.t()
  @type cities_map :: %{city() => coordinates()}
  @type result_map :: %{city() => temperature()}

  @doc """
  Calculates the mean temperature for each city in the given list.
  Fetches data concurrently using a task supervisor.

  ## Parameters
    - cities: A map of city names to their coordinates

  ## Returns
    A map with city names as keys and their mean temperatures as values.
    Temperatures are formatted with one decimal place and include the °C symbol.
    If there's an error fetching data for a city, its value will be "Error getting data".

  ## Examples
      iex> Tempex.Forecast.calculate_temperatures(%{"São Paulo" => %{latitude: -23.55, longitude: -46.63}})
      %{"São Paulo" => "23.9°C"}
  """
  @spec calculate_temperatures(cities_map()) :: result_map()
  def calculate_temperatures(cities) do
    cities
    |> Enum.map(&start_task/1)
    |> Task.await_many()
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  defp start_task({city, %{latitude: latitude, longitude: longitude}}) do
    Task.Supervisor.async_nolink(Tempex.ForecastSupervisor, fn ->
      case open_meteo_impl().get_forecast(latitude, longitude) do
        {:ok, %{"daily" => %{"temperature_2m_max" => temperatures}}} ->
          mean = calculate_mean(temperatures)
          %{city => format_temperature(mean)}

        {:error, _} ->
          %{city => "Error getting data"}
      end
    end)
  end

  defp calculate_mean([]), do: []

  defp calculate_mean(temperatures) do
    temperatures
    |> Enum.sum()
    |> Kernel./(Enum.count(temperatures))
  end

  defp format_temperature([]), do: "No data"

  defp format_temperature(temp) do
    temp
    |> Float.round(1)
    |> Float.to_string()
    |> Kernel.<>("°C")
  end

  defp open_meteo_impl do
    Application.get_env(:tempex, :open_meteo_impl)
  end
end
