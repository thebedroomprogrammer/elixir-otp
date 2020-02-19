defmodule KeyVal.DB do
  @db_path "./database"

  def start_link() do
    IO.puts("Starting Database")
    File.mkdir_p!(@db_path)
    children = Enum.map(1..5, &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end


  def child_spec(_) do
    %{
    id: __MODULE__,
    start: {__MODULE__, :start_link, []},
    type: :supervisor
}
  end

  defp worker_spec(worker_id) do
    initial_worker_spec = {KeyVal.DB_Worker, {@db_path, worker_id}}
    Supervisor.child_spec(initial_worker_spec, id: worker_id)
  end

  def get_worker() do
    :rand.uniform(5)
  end

  def save(store_name, data) do
    KeyVal.DB_Worker.save(get_worker(), store_name, data)
  end

  def fetch(store_name) do
    KeyVal.DB_Worker.fetch(get_worker(), store_name)
  end
end
