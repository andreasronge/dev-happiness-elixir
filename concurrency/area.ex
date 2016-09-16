defmodule Area do
  def loop() do
    receive do
      {from, {:rectangle, w, h}} ->
        send(from, w * h)
        loop()
      _ -> IO.puts "Unknown message"
    end
  end
end
