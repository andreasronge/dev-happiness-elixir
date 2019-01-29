defmodule MakkroTest do
  use ExUnit.Case
  doctest Makkro

  test "greets the world" do
    assert Makkro.hello() == :world
  end
end
