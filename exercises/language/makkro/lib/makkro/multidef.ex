defmodule What do
  defmacro __using__(options) do
    quote do
      # import unquote(__MODULE__)
      What.does_this_do(unquote(options))
    end
  end

  defmacro does_this_do(def_names) do
    for def_name <- def_names do
      quote do
        @doc "Hmm, what does this do ?"
        @spec unquote(def_name)() :: any()
        def unquote(def_name)(), do: IO.inspect(unquote(def_name))
      end
    end
  end
end

defmodule WhatDemo do
  use What, [:foo, :hej]

  def demo do
    foo()
    hej()
  end
end
