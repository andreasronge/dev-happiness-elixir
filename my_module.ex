defmodule MyModule do
  def sum(x, y) do
    x + y
  end

  # oneliner
  def add_one(x), do: sum(x, 1)  # No dot needed
end
