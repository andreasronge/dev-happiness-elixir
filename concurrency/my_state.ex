defmodule MyState do
  def loop(state) do
    receive do
      {from, {:get, key}} ->
        send(from, state[key])
        loop(state)
      {from, {:set, key, value}} ->
        loop(Map.put(state, key, value))
      _ -> IO.puts "Unknown message"
    end
  end
end
