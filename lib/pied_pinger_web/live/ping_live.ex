defmodule PiedPingerWeb.PingLive do
  use PiedPingerWeb, :live_view

  alias PiedPinger.{Pinger, PingServer}

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(PiedPinger.PubSub, "ping_live:all")
    end
    {:ok, assign(socket, url: "", results: [], message: "No results to display.")}
  end

  @impl true
  def handle_event("run_test", %{"url" => url}, socket) do
    case PingServer.multicall(url) do
      {:error, reason} ->
        {:noreply, assign(socket, message: "Invalid URL: #{inspect reason}", results: [], url: url)}
      _ ->
        {:noreply, assign(socket, message: "Running test", url: url)}
    end
  end

  defp ping_data_to_tuple(%Pinger{status_code: c, error: e, region: r}) do
    {r, "HTTP #{c}", e}
  end

  @impl true
  def handle_info({:results, record}, socket) do
    results = ping_data_to_tuple(record)
    socket = update(socket, :results, &([results | &1]))

    {:noreply, assign(socket, message: "")}
  end
end
