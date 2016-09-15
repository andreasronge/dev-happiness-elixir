# defmodule MyPlug do
#   import Plug.Conn
#
#   # Executed in compile time !
#   def init(options) do
#     options
#   end
#
#   #  @callback call(Plug.Conn.t, opts) :: Plug.Conn.t
#   def call(conn, _opts) do
#     conn
#     |> put_resp_content_type("text/plain")
#     |> send_resp(200, "Hello world")
#   end
# end


defmodule MyPlug do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec  # warn: false

    children = [
      worker(MyPlug.Hello, [])
    ]

    opts = [strategy: :one_for_one, name: MyPlug.Supervisor]
    IO.puts "Start called"
    Supervisor.start_link(children, opts)
  end

end
