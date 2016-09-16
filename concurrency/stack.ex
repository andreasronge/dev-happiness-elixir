defmodule Stack do
  use GenServer

  # API
  #  GenServer.cast(Stack, {:push, :hej})
  # GenServer.call(Stack, :pop)

  def start_link(state, _opts \\ []) do
    GenServer.start_link(__MODULE__, state, [name: Stack])
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def handle_cast({:push, h}, t) do
    {:noreply, [h | t]}
  end

end
