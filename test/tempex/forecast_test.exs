defmodule Tempex.ForecastTest do
  use ExUnit.Case, async: true

  describe "calculate_temperatures/1" do
    test "returns the forecast for the given cities when the request is successful" do
      cities = Tempex.Cities.list()

      Mox.expect(OpenMeteoMock, :get_forecast, 3, fn _latitude, _longitude ->
        {:ok, %{"daily" => %{"temperature_2m_max" => [22.7, 22.3, 23.7, 24.5, 26.0, 24.0]}}}
      end)

      assert Tempex.Forecast.calculate_temperatures(cities) == %{
               "São Paulo" => "23.9°C",
               "Belo Horizonte" => "23.9°C",
               "Curitiba" => "23.9°C"
             }
    end

    test "returns the forecast for the given cities when the request fails" do
      cities = Tempex.Cities.list()

      Mox.expect(OpenMeteoMock, :get_forecast, 3, fn _latitude, _longitude ->
        {:error, :service_unavailable}
      end)

      assert Tempex.Forecast.calculate_temperatures(cities) == %{
               "São Paulo" => "Error getting data",
               "Belo Horizonte" => "Error getting data",
               "Curitiba" => "Error getting data"
             }
    end

    test "return no data when some cities don't have data" do
      cities = Tempex.Cities.list()

      Mox.expect(OpenMeteoMock, :get_forecast, 3, fn _latitude, _longitude ->
        {:ok, %{"daily" => %{"temperature_2m_max" => []}}}
      end)

      assert Tempex.Forecast.calculate_temperatures(cities) == %{
               "Belo Horizonte" => "No data",
               "Curitiba" => "No data",
               "São Paulo" => "No data"
             }
    end
  end
end
