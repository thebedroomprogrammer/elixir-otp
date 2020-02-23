
defmodule KeyVal.Contractor do
  use Application

  def start(_types, _args) do
    KeyVal.System.start()
  end
end
