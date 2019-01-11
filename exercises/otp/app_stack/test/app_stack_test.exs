defmodule AppStackTest do
  use ExUnit.Case
  doctest AppStack

  test "greets the world" do
    assert AppStack.hello() == :world
  end
end
