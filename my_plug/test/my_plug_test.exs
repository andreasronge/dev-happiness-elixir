defmodule MyPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest MyPlug

  test "get" do
    conn = conn(:get, "/")
    response = MyPlug.call(conn, [])
    assert response.status == 200
  end
end
