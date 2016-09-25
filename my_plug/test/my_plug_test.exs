defmodule MyPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest MyPlug

  test "get" do
    conn = conn(:get, "/")
    response = MyPlug.Hello.call(conn, [])
    assert response.status == 201
  end
end
