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
    case PingServer.ping(url) do
      {:ok, _pid} ->
        {:noreply, assign(socket, message: "Running test", url: url)}
      {:error, reason} ->
        {:noreply, assign(socket, message: "Invalid URL: #{inspect reason}", results: [], url: url)}
    end
  end

  defp ping_data_to_tuple(%Pinger{status_code: c, error: e, region: r}) do
    {r, "HTTP #{c}", e}
  end

  # def handle_info({:result, result}, socket) do
  #   {:noreply, assign(socket, running: false, results: [result])}
  # end

  def handle_info({:results, record}, socket) do
    results = ping_data_to_tuple(record)
    {:noreply, assign(socket, message: "", results: [results])}
  end
end
