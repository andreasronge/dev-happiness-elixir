defmodule Typeexample do
  # def run, do: some_op(5, :you)

  # def some_op(a,b), do: a + b

  @spec some_op(String.t() | number, number) :: number
  def some_op(a, b), do: a + b

  def run, do: some_op("hej", 1)

  #   Typeexample.Calculator.add(x,y)

  # end

  # def bar() do
  #   foo("hej", "hopp")
  # end
end
