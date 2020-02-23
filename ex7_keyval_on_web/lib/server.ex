defmodule KeyVal.Server do
  use GenServer,restart: :transient

  def start_link(store_name) do
    IO.puts("Starting Server")
    GenServer.start_link(__MODULE__, store_name, name: via_tuple(store_name))
  end

  def init(store_name) do
    {:ok, {store_name, KeyVal.DB.fetch(store_name) || KeyVal.Store.new()}}
  end

  def put(store_name, key, value) do
    GenServer.cast(via_tuple(store_name), {:put, key, value})
  end

  def get(store_name, key) do
    GenServer.call(via_tuple(store_name), {:get, key})
  end

  def del(store_name, key) do
    GenServer.cast(via_tuple(store_name), {:del, key})
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

  defp via_tuple(name) do
    KeyVal.Registry.via_tuple({__MODULE__, name})
  end
end
