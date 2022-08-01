defmodule Weather do
  @api "http://api.openweathermap.org/data/2.5/weather?q="

  def get_appid() do
    System.get_env("API_KEY")
  end

  def get_endpoint(location) do
    location = URI.encode(location)

    "#{@api}#{location}&appid=#{get_appid()}"
  end
end
