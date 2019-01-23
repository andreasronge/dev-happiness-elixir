# Elixir Tools

TODO

[Back](/index.html)


## Content

* Debugging
* Mix/Hex
* Mix format
* Plug
* ExUnit
* Deployment with distillery
* [Google Cloud deploy](https://cloud.google.com/community/tutorials/elixir-phoenix-on-google-compute-engine)
* [gigalixir](https://gigalixir.com/)


## Debugging

* IEx.pry
* :debugger.start()
* IO.inspect
* More info [here](http://blog.plataformatec.com.br/2016/04/debugging-techniques-in-elixir-lang/)


## Mix

Generate a new project

```
mix new my_plug
cd my_plug
```


## Add a dependency

Edit `mix.exs`

```
def deps do
  [
    {:cowboy, "~> 2.6.1"}, #...
```


## Download

```
mix deps.get
mix deps.compile
# or just: mix do deps.get, compile
```


## Hex

The package manager for the Erlang ecosystem

```
mix hex.search foo
```

[http://hex.pm](https://hex.pm/)


## Code Formatation

```
mix format
```


## Mix XRef


```
mix xref unreachable
# TODO
```



## Plug

* A unified API that abstracts away the web library/framework.
* Stackable plugs, (`conn |> plug1 |> plug2`)


## Cowboy

* Small, fast, modular HTTP server written in Erlang


## Plug Example

Add to lib/my_plug.ex:

```elixir
defmodule MyPlug do
  import Plug.Conn

  # Executed in compile time !
  def init(options) do
    options
  end

  #  @callback call(Plug.Conn.t, opts) :: Plug.Conn.t
  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end
```


## test

Open iex with `iex -S mix`

```
{:ok, _} = Plug.Adapters.Cowboy.http MyPlug, []
```

Open browser http://localhost:4000


## more plug

```elixir
defmodule MyRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  forward "/users", to: UsersRouter

  match _ do
    send_resp(conn, 404, "oops")
  end
end
```


## Pattern matching

```elixir
def call(%Plug.Conn{request_path: "/" <> name} = conn, opts) do
  send_resp(conn, 200, "Hello, #{name}")
end
```


## ExUnit

```elixir
defmodule MyPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  doctest MyPlug

  test "get" do
    conn = conn(:get, "/")
    response = MyPlug.call(conn, [])
    assert response.status == 200
  end
end
```


## Error Reporting

Let the test fail, `assert response.status == 201`


```
1) test get (MyPlugTest)
   test/my_plug_test.exs:6
   Assertion with == failed
   code: response.status() == 201
   lhs:  200
   rhs:  201
   stacktrace:
     test/my_plug_test.exs:9: (test)
```


## Deployment

[distillery](https://hexdocs.pm/distillery/getting-started.html)

```
defp deps do
   [..., {:distillery, "~> 0.9.9"}]
end
```

`mix deps.get`


## create a release

```
my_plug (master) mix release.init  # only first time

my_plug (master) $ mix release
==> Assembling release..
==> Building release my_plug:0.1.0 using environment dev
==> You have set dev_mode to true, skipping archival phase
==> Release successfully built!
    You can run it in one of the following ways:
      Interactive: rel/my_plug/bin/my_plug console
      Foreground: rel/my_plug/bin/my_plug foreground
      Daemon: rel/my_plug/bin/my_plug start
```


## start

`rel/my_plug/bin/my_plug start`


## hot upgrades

```
my_plug (master) $ mix release --upgrade
Compiling 2 files (.ex)
...
==> Release successfully built!
    You can run it in one of the following ways:
      Interactive: rel/my_plug/bin/my_plug console
      Foreground: rel/my_plug/bin/my_plug foreground
      Daemon: rel/my_plug/bin/my_plug start

my_plug (master) $ rel/my_plug/bin/my_plug upgrade 0.2.1
Release 0.2.1 not found, attempting to unpack releases/0.2.1/my_plug.tar.gz
Unpacked successfully: "0.2.1"
Installed Release: 0.2.1
Made release permanent: "0.2.1"
```
