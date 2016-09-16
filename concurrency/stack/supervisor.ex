defmodule Stack.Supervisor do
  use Supervisor

  @stack_name My.Stack

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(Stack, [[name: @stack_name]])
    ]

    # supervise/2 is imported from Supervisor.Spec
    supervise(children, strategy: :one_for_one)
  end
end
