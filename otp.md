# OTP

Concurrency and the Erlang Runtime

[Back](index.html)


# Content

* Beam runtime & Processes
* OTP GenServer
* OTP Supervisors
* Distributed Elixir
* OTP Applications
* OTP Distribution/Distillery



# The Runtime

* Executes BEAM code. 
* Actor Model based concurrence
  * Message passing - share nothing
  * all code runs inside processes
  * extremely lightweight, 2KB per process (Java >1MB thread)
  * impossible to block a thread (unlike Java)


## Soft and Hard Realtime

* Soft real-time
  * Some requests might miss the deadlines.
* Hard real-time
  * you must absolutely hit every deadline.


## Garbage collection

* each process has a private heap that is garbage collected independently


## Preemtive scheduling

* Erlang does preemptive multitasking and gets soft-realtime right. 
* Values low latency over raw throughput (unusual)
* Preemption means that the scheduler can force a task off execution.

See [here](http://jlouisramblings.blogspot.com/2013/01/how-erlang-does-scheduling.html)


## Sceduling

Scedulers has run queues with runnable processes
(source [Erlang Factory](http://www.erlang-factory.com/upload/presentations/105/KennethLundin-ErlangFactory2009London-AboutErlangOTPandMulti-coreperformanceinparticular.pdf))

[<img src="img/erlang-smp.png">](img/erlang-smp.png)


## Creating a new process

* `spawn((() -> any)) :: pid`
* `spawn(module, atom, list) :: pid`
* `spawn_link(module, atom, list) :: pid`
* `spawn_monitor((() -> any)) :: {pid, reference}`


## Sending

* send is asynchronoues
* send a message to a mail box

```
iex> send self(), "hello world"
"hello world"
iex> flush # empty and checks what's in the mail box
"hello world"
```


## receive

* Each process has a mail box
* in receive block:
* * messages are removed if matched
* * unmatched messages are retried later
* * none matching message suspends the process
* * timeout can be specified


## Example

```elixir
current = self()
child   = spawn(fn -> send current, {self(), 3} end)

receive do
   {^child, x} -> IO.puts "Received #{x} back"
end
```


## How keep process alive ?

we want to send another message

```
iex> Process.alive? child
```


## Calculate Area

```elixir
defmodule Area do
  def loop() do
    receive do
      {from, {:rectangle, w, h}} ->
        send(from, w * h)
        loop()  # This is how keep it alive
      _ -> IO.puts "Unknown message"
    end
  end
end
```

```
iex> pid = spawn(Area, :loop, [])
iex> send(pid, {self(), {:rectangle, 2,3}})
iex> flush
```


## Exercise

Create a process that holds state so that:

```
iex> pid = spawn(MyState, :loop, [%{bar: "foo"}])
iex> send(pid, {:get, :bar, self()})
iex> flush
"foo"
iex> send(pid, {:set, :bar, "baaz"})
iex> send(pid, {:get, :bar})
iex> flush
"baaz"
```


## Solution

```elixir
defmodule MyState do
  def loop(state) do
    receive do
      {from, {:get, key}} ->
        send(from, state[key])
        loop(state)
      {from, {:set, key, value}} ->
        loop(Map.put(state, key, value))
      _ -> IO.puts "Unknown message"
    end
  end
end
```


## I/O Calls

* IO device is a process.
* Allows read/write files between remote nodes
* Process group leader for IO processes acts as a proxies for sending back reply from remote nodes.

```
e = Process.whereis(:standard_error)
IO.puts(e, "hej")
```


## Example, IO

```elixir
defmodule MYIODevice do
  def listen() do
    receive do
      {:io_request, from, reply_as, {:put_chars, :unicode, message}} ->
        send(from, {:io_reply, reply_as, :ok})
        IO.puts(message)
        IO.puts("I see you")
        listen()
    end
  end
end
pid = spawn_link(MYIODevice, :listen, [])
IO.puts(pid, "Hey there")
# See https://til.hashrocket.com/posts/ahjvkb6zqv-comply-with-the-erlang-io-protocol
```


## When to use Processes

* Need state ?
* Need concurrency and asynchronously ?
* Need limit access to components ?
* Need fault tolerance ?

Don't uses processes unless you need it !


## Agents

```
iex> {:ok, agent} = Agent.start_link fn -> [] end
{:ok, #PID<0.57.0>}
iex> Agent.update(agent, fn list -> ["eggs" | list] end)
:ok
iex> Agent.get(agent, fn list -> list end)
["eggs"]
iex> Agent.stop(agent)
:ok
```

Why keeping state in a separate process ?


## Tasks

```elixir
task = Task.async(fn -> do_some_work() end)
res  = do_some_other_work()
res + Task.await(task)
```


## Exit Signals

A process can terminate for 3 reasons:
1. Normal exit, normally ignored (reason: `:normal`)
2. Unhandled Error (e.g. matching error)
3. Killed (another process sends exit with reason `:kill`)


## Linking

* If two processes are linked then they will receive the others exit signal

* If the exit reason is not `:normal`, all the processes linked to the process that
exited will crash (unless they are trapping exits).


```elixir
defmodule Crash do
  def start_link, do: spawn_link(__MODULE__, :loop, [])
  def boom(pid), do: send(pid, :boom)

  def loop do
    receive do
      :boom -> throw "Boom"
    end
  end
```

```
iex> p = Crash.start_link
iex> Crash.boom(p)
** (EXIT from #PID<0.80.0>) an exception was raised:
** (ErlangError) erlang error: {:nocatch, "Boom"}
    crash.ex:21: Crash.loop/0

20:29:22.708 [error] Process #PID<0.157.0> raised an exception
(ErlangError) erlang error: {:nocatch, "Boom"}
    crash.ex:21: Crash.loop/0
Interactive Elixir (1.3.2) - press Ctrl+C to exit (type h() ENTER for help)
```


## Trapping exists

```
iex> Process.flag(:trap_exit, true)
iex> p = Crash.start_link
iex> Crash.boom(p)
iex>
20:37:36.700 [error] Process #PID<0.165.0> raised an exception
** (ErlangError) erlang error: {:nocatch, "Boom"}
    crash.ex:21: Crash.loop/0
iex> flush
{:EXIT, #PID<0.165.0>,
 {{:nocatch, "boom"}, [{Crash, :loop, 0, [file: 'crash.ex', line: 21]}]}}
```


## Exercise, trapping

```elixir
defmodule ExitDemo do
  def loop() do
    receive do
      :hi -> loop()
      :bye -> IO.puts "Bye"
      :boom -> throw "Boom"
    end

# What exit reason when sending ?
# * `:bye`
# * `:boom`
# * `:hello`
# * `:hi`
# * Process.exit(pid, :bla)
# * Process.exit(pid, :kill)
```


## Answer, bye

```
iex> Process.flag(:trap_exit, true)  
iex> pid = spawn_link(ExitDemo, :loop, [])
iex> send(pid, :bye)                      
iex> flush
{:EXIT, #PID<0.118.0>, :normal}
```


## Answer, boom

```
iex> Process.flag(:trap_exit, true)  
iex> pid = spawn_link(ExitDemo, :loop, [])
iex> send(pid, :boom)                      
iex> flush
{:EXIT, #PID<0.122.0>,
 {{:nocatch, "Boom"}, [{ExitDemo, :loop, 0, [file: 'exit.ex', line: 6]}]}}
```


## Exercise, Observer

```
iex> :observer.start

# * Find the Crash process
# * Send some unknown messages
# * Find the unknown messages
```



# What is OTP ?

* Included in Erlang/Elixir
* Framework to build fault-tolerant,scalable apps
* Debuggers, profilers, databases etc...


## OTP behaviours

* `:gen_server` stateful server process
* `:supervisor` recovery
* `:application` components/libraries
* `:gen_event` event handling
* `:gen_fsm` - finite state machine



# OTP: GenServer

* Generic part - behaviour
* Specific part - callback modules


## gen_server

A stateful server process
* Spawn a new process
* Run a loop
* Maintain process state
* React to messages
* Send response back


## Exercise, start_link

```elixir
defmodule MyGenServer do
  def start_link(module, args) do
    # TODO, impl this:
    # Calls init/1 function of the given module which returns
    # {:ok, state }
    # Starts a process linked to the current process calling
    # MyGenServer.loop with state as arg
    # Returns {:ok, pid}
  end

  def loop(state) do
  end
```


## Solution

```elixir
defmodule MyGenServer do
  def start_link(module, args) do
    {:ok, state} = module.init(args)
    pid = spawn_link(__MODULE__, :loop, [state])
    {:ok, pid}
  end

  def loop(module, state) do
  end
end

# iex> defmodule FooServer, do: (def init(_), do: {:ok, %{}})
# iex> {:ok, pid} = MyGenServer.start_link(FooServer, [])
```


## Exercise, init

Make `init` into a callback behaviour  

```elixir
@callback init(args:: term) :: {:ok, state:: any} | {:stop, reason:: any}
```


## Solution

```elixir
defmodule MyGenServer do
  @callback init(args:: term) :: {:ok, state:: any} | {:stop, reason:: any}
  # ...
end

defmodule FooServer do
  @behaviour MyGenServer
  @impl MyGenServer
  def init(_) do
    {:ok, %{}}  # initialize state with empty map
  end
end
```


## Exercise, handle_call

```
Impl. loop/receive so that message {:call, parent_pid, request}
calls your handle_call callback function.
```

```elixir
  @callback handle_call(request :: any, from :: pid, state :: any) ::
              {:reply, response :: any, new_state :: any}
```
Example:
```
{:ok, pid} = MyGenServer.start_link(FooServer, [])
send(pid, {:call, self(), :hello}) # calls FooServer.handle_call(:hello, parent_pid, state)
```


## Solution

```elixir
# MyGenServer loop:
    receive do
      {:call, from, request} ->
        {:reply, _, state} = module.handle_call(request, from, state)
        loop(module, state)
    end

# FooServer:    
  @impl MyGenServer
  def handle_call(request, from, state) do
    {:ok, :done, state}
  end
```


## Exercise, API

Create an API sync function `call` which receives the response from the server

```
defmodule FooServer do
  # ...
  def handle_call(:say_hello, _pid, state), 
    do: {:reply, "Hello", state}
  def handle_call(:say_goodbye, _pid, state), 
    do: {:reply, "Bye bye", state}

# Usage:
# {:ok, pid} = MyGenServer.start_link(FooServer, [])
# MyGenServer.call(pid, :say_hello) # => "Hello"
# MyGenServer.call(pid, :say_goodbye) # => "Bye bye"
```


## Solution

```elixir
  def call(pid, request) do
    send(pid, {:call, self(), request})
    receive do
      {^pid, response} -> response
    end
  end

  def loop(module, state) do
    receive do
      {:call, from, request} ->
        {:reply, response, new_state} = module.handle_call(request, self(), state)
        send(from, {self(), response})
        loop(module, state)
    end
  end
```
(Full source: [exercises/otp/my_gen_server](exercises/otp/my_gen_server/))


### GenServer Callbacks

* init/1
* terminate/2
* handle_call/3
* handle_cast
* handle_info
* code_change/3


## GenServer Module

* GenServer.start -> init/1
* GenServer.start_link -> init/1
* GenServer.stop -> terminate/2
* GenServer.call -> handle_call/3
* GenServer.cast -> handle_cast/2


## GenServer.handle_call/3

* Args: request, caller pid, state
* Returns: `{:reply, response, new_state}`

```elixir
# API
def pop(pid) do
  GenServer.call(pid, :pop) # Sync !
end

# Callback
def handle_call(:pop, _from, [h | t]) do
  {:reply, h, t}
end
```


## GenServer.handle_cast/2

* Args: request, state
* Returns: {:no_reply, new_state}

```elixir
# API
def push(pid, data) do
  GenServer.cast(pid, {:push, data}) # ASync !
end

# Callback
def handle_cast({:push, h}, t) do
  {:noreply, [h | t]}  # Async !
end
```


## OTP GenServer

```elixir
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
```


## Usage

```
iex> {_, pid} = MyStack.start_link([])
{:ok, #PID<0.94.0>}
iex> MyStack.push(pid, 42)
:ok
iex> MyStack.push(pid, 43)
:ok
iex> MyStack.pop(pid)
43
```


## Register PID

```elixir
defmodule MyStack.Server do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def push(data) do
    GenServer.cast(__MODULE__, {:push, data}) # ASync !
  end

  def pop() do
    GenServer.call(__MODULE__, :pop) # Sync !
  end

  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
```


## Let it crash

```
iex> MyStack.Server.start_link([42])
iex> MyStack.pop(pid)
42
iex> MyStack.pop(pid)
** (EXIT from #PID<0.80.0>) an exception was raised:
iex> MyStack.pop(pid)
** (CompileError) iex:2: undefined function pid/0  
```

What happened ?



# OTP supervisors


## Supervisor

* Manages one or more worker processes or supervisors
* Handles process exits, e.g. with a restart
* Impl. the GenServer behaviour
* Replace crashed processes with new  (let it crash)
* Supervisor trees


## How to write a supervisor

* impl the Supervisor behaviour: (`use Supervisor`)
* `YourModule.start_link/1` - calls [Supervisor.start_link](https://hexdocs.pm/elixir/Supervisor.html#start_link/2)
* `YourModule.init/1` - calls [Supervisor.init](https://hexdocs.pm/elixir/Supervisor.html#init/2) - which child processes to supervise


## Strategies

```
Supervisor.init(children, strategy: :one_for_one)
```

* `:one_for_one` - only that process is restarted.
* `:one_for_all` -  all child processes are restarted
* `:rest_for_one` - the rest of the children restarted


## Example

```elixir
defmodule MyStack.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :no_arg)
  end

  def init(:no_arg) do
    children = [
      MyStack.Server
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
```


## Full Example

See [exercises/otp/stack](exercises/otp/stack)

```elixir
defmodule MyStack do
  @server MyStack.Server

  def push(data) do
    GenServer.cast(@server, {:push, data}) # ASync !
  end

  def pop() do
    GenServer.call(@server, :pop) # Sync !
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
    Supervisor.start_link(__MODULE__, :no_arg)
  end

  def init(:no_arg) do
    children = [
      MyStack.Server
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
```


## Exercise

* What happens when you pop the last item on the stack ?
* Impl. a length function on the stack


## Child Specs

how supervisor should start, stop and restart 

```
iex(1)> MyStack.Server.child_spec(:hej)
%{id: MyStack.Server, start: {MyStack.Server, :start_link, [:hej]}}
# also check: iex> h Supervisor  and h 
```


## Debugging GenServers

See :sys module 


## DynamicSupervisor

```elixir
defmodule MyApp.DynamicSupervisor do
  # Automatically defines child_spec/1
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker do
     DynamicSupervisor.start_child(__MODULE__, SomeWorker)
  end
end
```

note: Use :observer.start   


## Exercise

```
* Impl MyStack.Worker that calls MyStack.pop each 2 sec
* Use Process.send_after(self(), :work, 2000)
* Impl. def handle_info(:work, _)
* Kill the worker process (found by `:observer.start`) with `Process.exit(p1, :normal)`
```

Solution: [exercises/otp/job](exercises/otp/job)


## Links

* https://github.com/pragdave/component
* https://ferd.ca/the-hitchhiker-s-guide-to-the-unexpected.html

[<img src="img/supervision-tree.png">](img/supervision-tree.png)



# Distributed Elixir


## Node

An executing Erlang runtime system which has been given a name.
Connections are by default transitive.
Nodes are protected by a magic cookie system.


## Connected Nodes

```
# Give node a name
iex --sname foo@localhost
# Connecting this node to other node
iex(foo@localhost)> Node.connect :bar@localhost
true
iex(foo@localhost)> Node.list
[:bar@localhost]
```

```
 iex --sname bar@localhost
```


## Remote shell

debug/play around in a running application

```
 iex --sname baz --remsh foo@HOST
 # for more info:
 iex> h(IEx)
```


## Via LAN

Need shared cookie

```
iex --name one@192.168.0.42 --cookie secret
```


## Spawn

Creates a remote process on a node:

```
iex(foo@localhost)> Node.list
[:bar@localhost]
iex(foo@localhost)> called = self  # using closure
#PID<0.86.0>
iex(foo@localhost)> Node.spawn(:bar@localhost,
	fn -> send(called, {:response, "Hi"}) end)
#PID<8914.92.0>  # Different PID !
iex(foo@localhost)> flush
{:response, "Hi"}
```


## Ping Pong

```elixir
iex> pid = Node.spawn_link :"foo@computer-name", fn ->
...>   receive do
...>     {:ping, client} -> send client, :pong
...>   end
...> end
#PID<9014.59.0>
iex> send pid, {:ping, self()}
{:ping, #PID<0.73.0>}
iex> flush()
:pong
:ok
```


## Exercise

Access the `MyStack` on a remote node:

```elixir
GenServer.cast({MyStack.Server, :bar@localhost}, {:push, "hello"})
```


## Monitoring nodes

```
iex> :net_kernel.monitor_nodes(true)
# Shutdown and start bar node
iex> flush
{:nodedown, :bar@localhost}
{:nodeup, :bar@localhost}
```


## Global Registration

```global.register_name```  cluster wide alias

GenServer.start_link, name: {:global, :some_alias}


## Process Groups

* Multiple redundant processes
* `GenServer.multi_call` to update all


# OTP Application

* Used to package Erlang/OTP software
* Has a standard folder structure and config
* Lifecycle (`loaded`, `started`, `stopped`)
* OTP Behaviour
* Built by mix


## Why OTP Apps ?

* Reusable components
* Configure without recompile
* Runtime dependencies
* Automatic start


## OTP folder structure

* Example:
`_build/dev/lib/mystack/ebin/mystack.app`

* See also `mix help compile.app`


## OTP Behaviour

```elixir
# Example
defmodule Mystack.Application do 
  use Application

  def start(_type, _args) do
    MyStack.Supervisor.start_link
  end
end
```


## Mix File

```elixir
defmodule MyPlug.Mixfile do
  use Mix.Project

  def project do  
    # Description of the project ...
  end

  # Configuration for the OTP application
  def application do
    [
      mod: {MyPlug.Application, []}  # <- Here
    ]
  end

  defp deps do ...
```


## Extra Applications

* Applications starts automatically if listed in the deps function.
* If you want to start an optional application (like logger):

```
  def application do
    [
      extra_applications: [:logger], # <- Add this
      mod: {MyPlug.Application, []}
    ]
  end
```


##  Runtime deps

```
my_plug (master) $ mix app.tree
my_plug
+-- elixir
+-- logger
|   +-- elixir
+-- cowboy
|   +-- ranch
|   +-- cowlib
|   |   +-- crypto
|   +-- crypto
+-- plug
    +-- elixir
    +-- crypto
    +-- logger
    +-- mime
        +-- elixir
```


## Compile time deps

```				
my_plug (master) $ mix deps.tree
my_plug
+-- cowboy ~> 1.0.0 (Hex package)
|   +-- cowlib ~> 1.0.0 (Hex package)
|   +-- ranch ~> 1.0 (Hex package)
+-- plug ~> 1.0 (Hex package)
|   +-- cowboy ~> 1.0 (Hex package)
|   +-- mime ~> 1.0 (Hex package)+
+-- distillery ~> 0.9.9 (Hex package)
```


## Starting/Stopping

```
Application.start(:app_stack)
```


## Application Configuration

```
# mix file:
def application do [
  ...
  env: [port: 5454]  # default
]
```

or just
```
iex --erl "myplug port 5454" -S mix
# see also Application.get_env/2
```


## Runtime Config

```
Application.stop(:app_stack)
Application.put_env(:app_stack, :port, 1234)
Application.start(:app_stack)
```



## OTP Release

* Complete system: erlang runtime, otp applications, boot script
* Compiled for a target system
* Can perform hot upgrades and downgrades
* Can be remotely administered

[See also](http://erlang.org/doc/design_principles/release_structure.htm)


## Distillery

```
# mix.exs:
  defp deps do
    [
      {:distillery, "~> 2.0"}
```

```
 mix deps.get deps.compile
 mix release.init
 mix release
```


## Result

```
Release successfully built!
To start the release you have built, you can use one of the following tasks:

  # start a shell, like 'iex -S mix'
  > _build/dev/rel/app_stack/bin/app_stack console
  # start in the foreground, like 'mix run --no-halt'
  > _build/dev/rel/app_stack/bin/app_stack foreground
  # ....
```


## Resources

* [The Hitchhiker's Guide to Concurrency](https://learnyousomeerlang.com/the-hitchhikers-guide-to-concurrency)
* [Erlang in Anger](https://www.erlang-in-anger.com/)

[Back](index.html)
