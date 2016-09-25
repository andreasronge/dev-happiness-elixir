defmodule Crash do

	def start do
	  spawn(__MODULE__, :loop, [])
	end

	def start_link do
	  spawn_link(__MODULE__, :loop, [])
	end

	def hi(pid), do: send(pid, :hi)
  def bye(pid), do: send(pid, :bye)
  def ohh(pid), do: send(pid, :ohh)

	def loop do
	  receive do
	  	:hi ->
				IO.puts "Hi"
				loop
			:bye -> IO.puts "Bye"
			:ohh -> throw "Ohh"
	  end
	end
end
