defmodule OpenMeteo.APITest do
  use ExUnit.Case, async: true

  alias OpenMeteo.API

  describe "get_forecast/2" do
    test "returns the forecast for the given latitude and longitude" do
      body = %{
        "daily" => %{
          "temperature_2m_max" => [22.7, 22.3, 23.7, 24.5, 26.0, 24.0],
          "time" => [
            "2025-04-29",
            "2025-04-30",
            "2025-05-01",
            "2025-05-02",
            "2025-05-03",
            "2025-05-04"
          ]
        },
        "daily_units" => %{"temperature_2m_max" => "°C", "time" => "iso8601"},
        "elevation" => 737.0,
        "generationtime_ms" => 0.030159950256347656,
        "latitude" => -23.5,
        "longitude" => -46.5,
        "timezone" => "GMT",
        "timezone_abbreviation" => "GMT",
        "utc_offset_seconds" => 0
      }

      Req.Test.stub(API, fn conn ->
        Req.Test.json(conn, body)
      end)

      assert {:ok, ^body} = API.get_forecast(46.63, -23.55)
    end

    test "when the request return 500, should fail" do
      Req.Test.stub(API, fn conn ->
        Plug.Conn.resp(conn, 500, "Internal Server Error")
      end)

      assert {:error, :internal_server_error} = API.get_forecast(46.63, -23.55)
    end

    test "when the request return 503, should fail" do
      Req.Test.stub(API, fn conn ->
        Plug.Conn.resp(conn, 503, "Service Unavailable")
      end)

      assert {:error, :service_unavailable} = API.get_forecast(46.63, -23.55)
    end
  end
end
