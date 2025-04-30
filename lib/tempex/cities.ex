defmodule Tempex.Cities do
  @moduledoc """
  This module provides a list of cities with their latitude and longitude.
  """

  @cities %{
    "São Paulo" => %{latitude: -23.55, longitude: -46.63},
    "Belo Horizonte" => %{latitude: -19.92, longitude: -43.94},
    "Curitiba" => %{latitude: -25.43, longitude: -49.27}
  }

  @spec list() :: %{String.t() => %{latitude: float(), longitude: float()}}
  def list, do: @cities
end
