defmodule PiedPinger.Pinger do
  defstruct url: "", status_code: nil, run: false, result: nil, error: nil, region: nil

  @type t() :: %__MODULE__{url: String.t()}

  require Logger

  @spec new(any) :: Pinger.t()
  def new(url), do: %__MODULE__{url: url}

  @spec ping(binary | Pinger.t()) :: Pinger.t()
  def ping(url) when is_binary(url) do
    Logger.info("Running test on #{url}")
    %{scheme: s, host: h} = URI.parse(url)

    case {s, h} do
      {nil, _} -> {:error, :invalid_scheme}
      {_, nil} -> {:error, :invalid_host}
      _ ->
        Task.start(__MODULE__, :ping, [new(url)])
    end
  end

  def ping(%__MODULE__{url: url} = record) do
    Process.sleep(1_000)

    record
    |> Map.put(:run, true)
    |> Map.put(:region, region_name())
    |> Map.put(:result, HTTPoison.head(url))
    |> parse_error()
    |> parse_response_code()
    |> broadcast()
  end

  defp parse_error(%__MODULE__{result: {:error, reason}} = record) do
    Map.put(record, :error, HTTPoison.Error.message(reason))
  end
  defp parse_error(record), do: record

  defp parse_response_code(%__MODULE__{result: {:ok, result}} = record) do
    Map.put(record, :status_code, Map.get(result, :status_code))
  end
  defp parse_response_code(record), do: record

  defp broadcast(record) do
    Phoenix.PubSub.broadcast!(PiedPinger.PubSub, "ping_live:all", {:results, record})
    {:ok, record}
  end

  defp region_name, do: "Unknown"
end
