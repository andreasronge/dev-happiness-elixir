defmodule ExitDemo do
  def loop() do
    receive do
      :hi -> loop()
      :bye -> IO.puts("Bye")
      :boom -> throw("Boom")
    end
  end
end

# pid = spawn_link(ExitDemo, :loop, [])
