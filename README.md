# Weather

**Display the current temperature of one place or several simultaneously**


# Usage

### For one city
```console
foo@bar: iex -S mix
iex> Weather.temperature_of("São Paulo")
"São Paulo: 20.4 ºC"
```

### For multiple cities
```console
foo@bar: iex -S mix
iex> cities = ["São Paulo", "Rio de Janeiro", "Niteroi"]
iex> Weather.start(cities)
[
  {#PID<0.257.0>, "São Paulo"},
  {#PID<0.257.0>, "Rio de Janeiro"},
  {#PID<0.257.0>, "Niteroi"}
]
Niteroi: 23.2 ºC, Rio de Janeiro: 23.3 ºC, São Paulo: 20.4 ºC

```