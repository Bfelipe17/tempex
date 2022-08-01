defmodule WeatherTest do
  use ExUnit.Case
  doctest Weather

  @api "http://api.openweathermap.org/data/2.5/weather?q="

  test "should return a encoded endpoint when take a location" do
    appid = Weather.get_appid()
    endpoint = Weather.get_endpoint("Rio de Janeiro")

    assert "#{@api}Rio%20de%20Janeiro&appid=#{appid}" == endpoint
  end

  test "should return Celsius when take Kelvin" do
    kelvin = 296.48
    celsius = 23.3
    temperature = Weather.kelvin_to_celsius(kelvin)

    assert temperature == celsius
  end
end
