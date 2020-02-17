defmodule KeyVal.Manager do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil,name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def create_store(store_name) do
    GenServer.call(__MODULE__, {:create_store, store_name})
  end

  def handle_call({:create_store, store_name}, _, state) do
    case Map.fetch(state, store_name) do
      {:ok, server} ->
        {:reply, server, state}

      :error ->
        {:ok, pid} = KeyVal.Server.start()
        {:reply, pid, Map.put(state, store_name, pid)}
    end
  end
end
