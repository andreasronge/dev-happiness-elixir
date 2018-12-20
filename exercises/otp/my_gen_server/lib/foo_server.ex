defmodule FooServer do
  @behaviour MyGenServer
  @impl MyGenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl MyGenServer
  def handle_call(:say_hello, _pid, state), do: {:reply, "Hello", state}
  def handle_call(:say_goodbye, _pid, state), do: {:reply, "Bye bye", state}
end

# {:ok, pid} = MyGenServer.start_link(FooServer, [])
# MyGenServer.call(pid, :say_hello) # => "Hello"
# MyGenServer.call(pid, :say_goodbye) # => "Bye bye"
