# See https://til.hashrocket.com/posts/ahjvkb6zqv-comply-with-the-erlang-io-protocol
defmodule MYIODevice do
  def listen() do
    receive do
      {:io_request, from, reply_as, {:put_chars, :unicode, message}} ->
        send(from, {:io_reply, reply_as, :ok})
        IO.puts(message)
        IO.puts("I see you")
        listen()
    end
  end
end
