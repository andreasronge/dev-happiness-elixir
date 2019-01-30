defmodule Spekt do
  defmacro spekt(name_ast) do
    # %Macro.Env{file: file, line: line} = __CALLER__
    # [_, file_name] = Regex.run(~r[.*/(\w*)], file)
    # at_file = "[#{file_name}.ex:#{Integer.to_string(line)}] "
    # {var_name, _, _} = name

    {at_file, var_name} =
      with %Macro.Env{file: file, line: line} <- __CALLER__,
           {var_name, _, _} <- name_ast,
           [_, file_name] <- Regex.run(~r[.*/(\w*)], file) do
        {"[#{file_name}.ex:#{line}]", var_name}
      end

    quote do
      inspected_value = inspect(unquote(name_ast), pretty: true)
      IO.puts(unquote(at_file) <> Atom.to_string(unquote(var_name)) <> "=" <> inspected_value)
    end
  end
end

defmodule SpektDemo do
  import Spekt
  #  use Spekt

  def foo do
    for x <- [:a, :b] do
      spekt(x)
    end

    foo = %{hej: "hopp"}
    spekt(foo)
  end
end
