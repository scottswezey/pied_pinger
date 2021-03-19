defmodule PiedPinger.PingServer do
  use GenServer

  alias PiedPinger.Pinger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def multicall(url, sid \\ "all") do
    %{scheme: s, host: h} = URI.parse(url)

    case {s, h} do
      {nil, _} -> {:error, :invalid_scheme}
      {_, nil} -> {:error, :invalid_host}
      _ ->
        all_nodes = Node.list() ++ [Node.self]
        :erpc.multicall(all_nodes, __MODULE__, :ping, [url, sid])
    end
  end

  def ping(url, sid), do: GenServer.call(__MODULE__, {:test, url, sid})

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:test, url, sid}, _from, state) do
    {:reply, Pinger.ping(url, sid), state}
  end
end
