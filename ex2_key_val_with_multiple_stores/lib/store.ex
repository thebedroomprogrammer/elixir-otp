defmodule KeyVal.Store do
  def new() do
    %{}
  end

  def put(store, key, value) do
    Map.put(store, key, value)
  end

  def get(store, key) do
    Map.fetch(store, key)
  end

  def del(store, key) do
    Map.delete(store, key)
  end
end
