defmodule MyPlug.Hello do
  import Plug.Conn

  def init(options) do
    options
  end

  def start_link do
    {:ok, _} = Plug.Adapters.Cowboy.http MyPlug.Hello, [], port: 1234
  end


  #  @callback call(Plug.Conn.t, opts) :: Plug.Conn.t
  def call(conn, _opts) do
    IO.puts "GOT CONNECTION"
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
