defmodule PiedPinger.Pinger do
  alias PiedPinger.FlyRegion
  require Logger

  defstruct url: "", status_code: nil, run: false, result: nil, error: nil, region: nil

  @type t() :: %__MODULE__{url: String.t()}

  @spec new(binary) :: Pinger.t()
  def new(url), do: %__MODULE__{url: url}

  @spec ping(binary | Pinger.t(), binary) :: Pinger.t()
  def ping(url, sid) when is_binary(url) do
    Logger.info("Running test on #{url}")
    Task.start(__MODULE__, :ping, [new(url), sid])
  end

  def ping(%__MODULE__{url: url} = record, sid) do
    record
    |> Map.put(:run, true)
    |> Map.put(:region, region_name())
    |> Map.put(:result, HTTPoison.head(url))
    |> parse_error()
    |> parse_response_code()
    |> broadcast(sid)
  end

  defp parse_error(%__MODULE__{result: {:error, reason}} = record) do
    Map.put(record, :error, HTTPoison.Error.message(reason))
  end
  defp parse_error(record), do: record

  defp parse_response_code(%__MODULE__{result: {:ok, result}} = record) do
    Map.put(record, :status_code, Map.get(result, :status_code))
  end
  defp parse_response_code(record), do: record

  defp broadcast(record, sid) do
    Phoenix.PubSub.broadcast!(PiedPinger.PubSub, "ping_live:#{sid}", {:results, record})
    {:ok, record}
  end

  defp region_name, do: System.get_env("FLY_REGION", "Unknown") |> FlyRegion.location_for_code()
end
