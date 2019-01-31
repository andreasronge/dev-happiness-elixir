defmodule Hello do
  defmacro hello_macro do
    quote do
      def say_hello do
        IO.puts "Hello"
      end
    end
  end
end

defmodule HelloDemo do
  require Hello
  Hello.hello_macro
end


defmodule HelloMagic do
  defmacro __using__(_options) do
    quote do
      def say_hello, do: IO.puts "Hello"
    end
  end
end

defmodule HelloMagicDemo do
  use HelloMagic
end

# HelloMagicDemo.say_hello
