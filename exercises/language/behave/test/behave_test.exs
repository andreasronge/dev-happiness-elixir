defmodule BehaveTest do
  use ExUnit.Case
  doctest Behave

  test "greets the world" do
    assert Behave.hello() == :world
  end
end
