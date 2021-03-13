defmodule PiedPinger.PingServer do
  use GenServer

  alias PiedPinger.Pinger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def ping(url), do: GenServer.call(__MODULE__, {:test, url})

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:test, url}, _from, state) do
    {:reply, Pinger.ping(url), state}
  end
end
