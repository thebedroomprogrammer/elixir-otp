defmodule KeyVal.System do
  use Supervisor

  def start do
    Supervisor.start_link(__MODULE__,nil)
  end

  def init(_) do
      Supervisor.init([KeyVal.Manager,KeyVal.DB], strategy: :one_for_one)
  end
end
