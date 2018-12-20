defmodule MyStack do
  @server MyStack.Server

  def push(data) do
    # ASync !
    GenServer.cast(@server, {:push, data})
  end

  def pop() do
    # Sync !
    GenServer.call(@server, :pop)
  end
end

defmodule MyStack.Server do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}

  @impl true
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end

defmodule MyStack.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    children = [
      worker(MyStack.Server, [["initial value"]])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
