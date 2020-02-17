defmodule AGenServerTest do
  use ExUnit.Case
  doctest AGenServer

  test "greets the world" do
    assert AGenServer.hello() == :world
  end
end
