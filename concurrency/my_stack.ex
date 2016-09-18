defmodule MyStack do
  use GenServer # thin wrapper around OTP's :gen_server

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def push(pid, data) do
    GenServer.cast(pid, {:push, data}) # ASync !
  end

  def pop(pid) do
    GenServer.call(pid, :pop) # Sync !
  end

  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
