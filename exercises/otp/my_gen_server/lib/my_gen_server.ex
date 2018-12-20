defmodule MyGenServer do
  @callback init(args :: any) :: {:ok, state :: any} | {:stop, reason :: any}
  @callback handle_call(request :: any, from :: pid, state :: any) ::
              {:reply, response :: any, new_state :: any}

  # start a process linked to the current process
  # once started the init/1 function of the given module is called with args
  def start_link(module, args) do
    {:ok, state} = apply(module, :init, [args])
    pid = spawn_link(__MODULE__, :loop, [module, state])
    {:ok, pid}
  end

  def call(pid, request) do
    send(pid, {:call, self(), request})

    receive do
      {^pid, response} -> response
      unknown -> IO.puts("Received unknown #{inspect(unknown)}")
    end
  end

  def loop(module, state) do
    receive do
      {:call, from, request} ->
        IO.puts("Received from: #{inspect(from)} request: #{inspect(request)}}")
        {:reply, response, new_state} = module.handle_call(request, self(), state)
        send(from, {self(), response})
        loop(module, state)
    end
  end
end
