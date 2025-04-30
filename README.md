# Tempex

A simple Elixir application to fetch and display temperature forecasts for multiple cities concurrently.

## Features

- Concurrent temperature fetching for multiple cities
- Mean temperature calculation
- Formatted temperature display with °C symbol
- Task supervision for reliable concurrent operations

## Usage

```elixir
# Get temperatures for all cities
Tempex.Forecast.calculate_temperatures(Tempex.Cities.list())

# Example output:
%{
  "Belo Horizonte" => "23.9°C",
  "Curitiba" => "23.9°C",
  "São Paulo" => "23.9°C"
}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tempex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tempex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tempex>.

