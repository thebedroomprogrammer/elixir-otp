defmodule KeyVal.Server do
  use GenServer

  def start(store_name) do
    GenServer.start(__MODULE__, store_name)
  end

  def init(store_name) do
    {:ok, {store_name, KeyVal.DB.fetch(store_name) || KeyVal.Store.new()}}
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

  def handle_call({:get, key}, _, {name, store}) do
    {:reply, KeyVal.Store.get(store, key), {name, store}}
  end

  def handle_cast({:put, key, value}, {name, store}) do
    new_state = KeyVal.Store.put(store, key, value)
    KeyVal.DB.save(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_cast({:del, key}, {name, store}) do
    new_state = KeyVal.Store.del(store, key)
    KeyVal.DB.save(name, new_state)
    {:noreply, {name, new_state}}
  end
end
