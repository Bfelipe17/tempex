defmodule Tempex do
  @moduledoc """
  Documentation for `Tempex`.
  """

  def forecast() do
    cities = Tempex.Cities.list()

    Tempex.Forecast.calculate_temperatures(cities)
  end
end
