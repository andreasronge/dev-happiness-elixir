defmodule MyStack.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
    # will call init with nil as argument
  end

  def init(_) do
    children = [
      worker(MyStack.Server, [["initial value"]])
    ]
    supervise(children, strategy: :one_for_one)
  end
end


defmodule MyStack do
  def start do
    MyStack.Supervisor.start_link
  end

  def push(data) do
    GenServer.cast(MyStack.Server, {:push, data}) # ASync !
  end

  def pop() do
    GenServer.call(MyStack.Server, :pop) # Sync !
  end
end

defmodule MyStack.Server do
  use GenServer

  def start_link(state) do
    GenServer.start_link(MyStack.Server, state, name: MyStack.Server)
  end

  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
