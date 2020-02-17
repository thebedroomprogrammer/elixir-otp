defmodule KeyVal.DB do
  use GenServer

  @db_path "./database"

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    File.mkdir_p(@db_path)
    {:ok, nil}
  end

  def save(store_name, data) do
    GenServer.cast(__MODULE__, {:save, store_name, data})
  end

  def fetch(store_name) do
    GenServer.call(__MODULE__, {:fetch, store_name})
  end

  def handle_call({:fetch, store_name}, _, state) do
    data =
      case File.read(get_path(store_name)) do
        {:ok, file_content} -> :erlang.binary_to_term(file_content)
        _ -> nil
      end

    {:reply, data, state}
  end

  def handle_cast({:save, store_name, data}, state) do
    File.write!(get_path(store_name), :erlang.term_to_binary(data))
    {:noreply, state}
  end

  def get_path(store_name) do
    Path.join(@db_path, store_name)
  end
end
