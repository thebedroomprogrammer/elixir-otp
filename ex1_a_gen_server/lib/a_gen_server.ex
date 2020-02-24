defmodule KeyVal.Server do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    {:ok, %{}}
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def del(pid, key) do
    GenServer.cast(pid, {:del, key})
  end

  def handle_call({:get, key}, _, state) do
    {:reply, Map.fetch(state, key), state}
  end

  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  def handle_cast({:del, key}, state) do
    {:noreply, Map.delete(state, key)}
  end
end
