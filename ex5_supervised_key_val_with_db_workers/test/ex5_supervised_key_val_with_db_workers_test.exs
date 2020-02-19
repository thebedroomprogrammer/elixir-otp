defmodule Ex5SupervisedKeyValWithDbWorkersTest do
  use ExUnit.Case
  doctest Ex5SupervisedKeyValWithDbWorkers

  test "greets the world" do
    assert Ex5SupervisedKeyValWithDbWorkers.hello() == :world
  end
end
