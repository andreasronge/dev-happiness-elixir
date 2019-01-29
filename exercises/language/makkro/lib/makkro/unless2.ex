defmodule Unless2 do
  defmacro __using__(_) do
    quote do
      import Unless2
    end
  end

  defmacro my_unless(clause, do: expression) do
    # IO.puts("Module #{inspect(__MODULE__)} " <> inspect(expression, pretty: true))

    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end
end

defmodule UnlessDemo2 do
  use Unless2

  def demo do
    my_unless false do
      IO.puts("YEAH")
    end
  end
end
