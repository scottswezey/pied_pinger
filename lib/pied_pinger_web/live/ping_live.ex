defmodule PiedPingerWeb.PingLive do
  use PiedPingerWeb, :live_view

  alias PiedPinger.{Pinger, PingServer}

  @impl true
  def mount(_params, _session, socket) do
    session_id = :crypto.strong_rand_bytes(32) |> Base.url_encode64()
    if connected?(socket) do
      Phoenix.PubSub.subscribe(PiedPinger.PubSub, "ping_live:#{session_id}")
    end
    {:ok, assign(socket, session_id: session_id, url: "", results: [], message: "No results to display.")}
  end

  @impl true
  def handle_event("run_test", %{"url" => url}, %{assigns: %{session_id: sid}} = socket) do
    case PingServer.multicall(url, sid) do
      {:error, reason} ->
        {:noreply, assign(socket, message: "Invalid URL: #{inspect reason}", results: [], url: url)}
      _ ->
        {:noreply, assign(socket, message: "Running test", url: url, results: [])}
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
