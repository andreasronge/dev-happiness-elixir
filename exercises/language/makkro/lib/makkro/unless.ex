defmodule Unless do
  defmacro macro_unless(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end
end

defmodule UnlessDemo do
  def demo do
    require Unless

    Unless.macro_unless false do
      IO.puts("YEAH")
    end
  end
end
