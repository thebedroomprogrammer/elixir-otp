defmodule KeyVal.System do
  use Supervisor

  def start do
    Supervisor.start_link([KeyVal.Manager,KeyVal.DB], strategy: :one_for_one)
  end
end
