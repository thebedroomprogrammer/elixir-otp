defmodule KeyVal.DB do
  use GenServer
  @db_path "./database"

  def start_link(_) do
    IO.puts "Starting Database"
   GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    File.mkdir_p!(@db_path)
    {:ok, spawn_workers()}
  end

  def spawn_workers() do
    for idx <- 1..5, into: %{} do
      {:ok, pid} = KeyVal.DB_Worker.start(@db_path)
      {idx, pid}
    end
  end

  def get_worker do
    random_key = :rand.uniform(5)
    GenServer.call(__MODULE__, {:get_worker, random_key})
  end

  def handle_call({:get_worker, key}, _, workers) do
    {:reply, Map.get(workers, key), workers}
  end

  def save(store_name, data) do
    KeyVal.DB_Worker.save(get_worker(), store_name, data)
  end

  def fetch(store_name) do
    KeyVal.DB_Worker.fetch(get_worker(), store_name)
  end
end
