defmodule KeyVal.Manager do
  def start_link() do
    IO.puts("Starting Manager")
    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  defp start_child(store_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {KeyVal.Server, store_name}
    )
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end


  def create_store(store_name) do
    case start_child(store_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end
end
