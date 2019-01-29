defmodule Spekt do
  defmacro __using__(_) do
    quote do
      import Spekt
      require Spekt
    end
  end

  defmacro spekt(name) do
    %Macro.Env{file: file, line: line} = __CALLER__
    [_, file_name | []] = Regex.run(~r[.*/(\w*)], file)
    at_file = "#{file_name}.ex:#{Integer.to_string(line)}> "
    {var_name, _, _} = name

    quote do
      inspected_value = inspect(unquote(name), pretty: true)
      IO.puts(unquote(at_file) <> Atom.to_string(unquote(var_name)) <> "=" <> inspected_value)
    end
  end
end

defmodule SpektDemo do
  use Spekt

  def foo do
    for x <- [:a, :b] do
      spekt(x)
    end

    foo = %{hej: "hopp"}
    spekt(foo)
  end
end
