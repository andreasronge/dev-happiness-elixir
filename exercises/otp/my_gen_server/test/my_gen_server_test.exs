defmodule MyGenServerTest do
  use ExUnit.Case

  setup do
    # Notice, testing proper OTP GenServer should do this instead:
    # See https://elixir-lang.org/getting-started/mix-otp/genserver.html
    # {:ok, pid} = start_supervised!(MyGenServer, [FooServer, []])
    {:ok, pid} = MyGenServer.start_link(FooServer, [])
    %{pid: pid}
  end

  test "works as expected", %{pid: pid} do
    assert MyGenServer.call(pid, :say_hello) == "Hello"
  end
end
