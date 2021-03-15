defmodule PiedPinger.FlyRegion do
  # Valid as of March 15, 2021
  # Update running `flyctl platform regions` on CLI with flyctl installed
  @source """
  ams Amsterdam, Netherlands
  atl Atlanta, Georgia (US)
  cdg Paris, France
  dfw Dallas 2, Texas (US)
  ewr Secaucus, NJ (US)
  fra Frankfurt, Germany
  hkg Hong Kong
  iad Ashburn, Virginia (US)
  lax Los Angeles, California (US)
  lhr London, United Kingdom
  nrt Tokyo, Japan
  ord Chicago, Illinois (US)
  scl Santiago, Chile
  sea Seattle, Washington (US)
  sin Singapore
  sjc Sunnyvale, California (US)
  syd Sydney, Australia
  yyz Toronto, Canada
  """
  |> String.split("\n")
  |> Enum.flat_map(&String.split(&1, " ", parts: 2, trim: true))
  |> Enum.chunk_every(2)
  |> Enum.map(fn row ->
    abreviation = row |> hd() |> String.to_atom()

    {abreviation, Enum.at(row, 1)}
  end)
  |> Map.new()
  |> IO.inspect()

  @spec location_for_code(atom()) :: String.t()
  def location_for_code(code) when is_atom(code) do
    Map.get(@source, code, "Unknown Region")
  end

  def location_for_code(code) when is_binary(code), do: code |> String.to_atom |> location_for_code()
end
