defmodule KeyVal.DB_Worker do
  use GenServer

  def start_link({db_path,worker_id}) do
    IO.puts("Starting DB Worker")
    GenServer.start_link(__MODULE__, db_path,name: via_tuple(worker_id))
  end

  def init(db_path) do
    {:ok, db_path}
  end

  def save(worker_id, store_name, data) do
    GenServer.cast(via_tuple(worker_id), {:save, store_name, data})
  end

  def fetch(worker_id, store_name) do
    GenServer.call(via_tuple(worker_id), {:fetch, store_name})
  end

  def handle_call({:fetch, store_name}, _, db_path) do
    data =
      case File.read(get_path(store_name, db_path)) do
        {:ok, file_content} -> :erlang.binary_to_term(file_content)
        _ -> nil
      end

    {:reply, data, db_path}
  end

  def handle_cast({:save, store_name, data}, db_path) do
    File.write!(get_path(store_name, db_path), :erlang.term_to_binary(data))
    {:noreply, db_path}
  end

  def get_path(store_name, db_path) do
    Path.join(db_path, store_name)
  end

  def via_tuple(worker_id) do
    KeyVal.Registry.via_tuple({__MODULE__,worker_id})
  end
end
