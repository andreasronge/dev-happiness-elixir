defmodule Job do
  def start_link do
    Job.Supervisor.start_link()
  end

  def add_worker do
    Job.Worker.Supervisor.add_worker()
  end

  def add_jobs(jobs) do
    jobs |> Enum.each(&Job.Registry.push/1)
  end
end

defmodule Job.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    children = [
      {Job.Registry, [[]]},
      Job.Worker.Supervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule Job.Worker do
  # , restart: :transient
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  @impl true
  def init(:no_args) do
    IO.puts("started Job.Registry #{inspect(self())}")
    Process.send_after(self(), :work, 0)
    {:ok, nil}
  end

  @impl true
  def handle_info(:work, _) do
    if Job.Registry.length() > 0 do
      work = Job.Registry.pop()
      IO.puts("Job.Worker done job #{inspect(work)}")
    end

    Process.send_after(self(), :work, 2000)
    {:noreply, nil}
  end
end

defmodule Job.Worker.Supervisor do
  use DynamicSupervisor

  @me Job.Worker.Supervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_worker() do
    {:ok, _pid} = DynamicSupervisor.start_child(@me, Job.Worker)
  end
end

defmodule Job.Registry do
  use GenServer

  @impl true
  def init(args) do
    IO.puts("started Job.Registry #{inspect(self())}")
    {:ok, args}
  end

  def push(data) do
    GenServer.cast(__MODULE__, {:push, data})
  end

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def length do
    GenServer.call(__MODULE__, :length)
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_call(:length, _from, state), do: {:reply, length(state), state}

  @impl true
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
