# Why Elixir ?

More than a language

[Back](index.html)


## What is Erlang/OTP ?

* Functional Language
* Distributed Runtime System
* Tooling/Libraries/Design principles


## History

* 1985 - Built for Ericsson AXE telephone exhange
* 1998 - Open sourced (9 nines)
* 2007 - Rabbit MQ, Whats Up (2,277,845)
* 2014 - Elixir 1.0
* 2015 - Phoenix 1.0
* 2018 - Nerves 1.0

mature => ready to use


## Erlang

* Fault-tolerant
* High availability
* Hot code replacement
* Self healing network
* Distributed
* Soft real-time
* Hot swapping of code


## Use Cases

* Parallel computing
* Web Apps
* Embedded


## How, Beam

* OS for distributed computing
  * isolated processes
  * message passing


## Actor Model

[<img src="https://cdn-images-1.medium.com/max/1600/1*dP7zn0FuqLGRkd_1vimsxw.png">](https://cdn-images-1.medium.com/max/1600/1*dP7zn0FuqLGRkd_1vimsxw.png)


## Elixir Example

State via Recursion

```elixir
defmodule MyState do
  def loop(state) do
    receive do
      {from, {:set, key, value}} ->
        loop(Map.put(state, key, value))
    end
  end
end
# pid = spawn(MyState, :loop, [%{bar: "foo"}])
```


## OTP

* A distributed runtime system (OS)
* Tooling and behaviours for parallel processing
* How to design/distribute/config/reuse...


## What is Elixir ?

* Functional programming language
* Run on Erlang VM (BEAM)
* Compiles to bytecode for BEAM


## Why Elixir, 1

* Erlang and OTP (!)
* Since using Elixir:
  * Better productivity and extensibility
  * Modern functional language
  * Great tooling
  * Compatibility with Erlang's eco system


## Why Elixir, 2

* Stable language
* Extensible design (macros, protocols)
* Easy to learn - explicit, no magic
* First class documentation
* Syntax matters => maintainable code
* Excellent testing support
* Support on Google Cloud and soon on AWS Lambda
* Fun and productive language !


## Why Elixir, 3

* Built in tooling: e.g build/docs/monitoring/testing/code formatter ...
* Phoenix webframework
* Great people/community: Dave Thomas (pragdave), Bruce Tate, Jose Valim
* Paradigm shift
* [Companies using elixir](https://github.com/doomspork/elixir-companies/blob/master/src/_data/companies.yml)


## Example, Supervisors

[<img src="img/actors.png">](https://buildplease.com/pages/supervisors-csharp/)


## Example, Plug

```elixir
# https://github.com/elixir-plug/plug/blob/master/README.md
def hello_world_plug(conn, _opts) do
  conn
  |> put_resp_content_type("text/plain")
  |> send_resp(200, "Hello world")
end
```


## Example, Pattern Matching

```elixir
defmodule Fib do 
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end
end
```


## Paradigm shift ?

```elixir 
  def update({:increment, n}, state, session) do
    {:ok, state + n, session}
  end
  def update({:decrement, n}, state, session) do
    {:ok, state - n, session}
  end

  def view(state, _session) do
   ~H"""
    <div>
      <button on-click={{ :increment }}>+</button>
      <span>The current number is: {{ state }}></span>
      <button on-click={{ :decrement }}>-</button>
    </div>
    """
  end
```


## Example, ExUnit

```
test "the truth" do
    assert 1 + 1 == 3
end

1) test the truth (HelloExunitTest)
   test/hello_exunit_test.exs:5
   Assertion with == failed
   code: 1 + 1 == 3
   lhs:  2
   rhs:  3
   stacktrace:
     test/hello_exunit_test.exs:6: (test)

Finished in 0.05 seconds
1 test, 1 failure
```


## Example, Docs

[<img src="img/iex-doc.png">](img/iex-doc.png)


## Example, Docs

[<img src="img/hexdoc.png">](img/hexdoc.png)


## Example, VsCode

[<img src="img/vscode-elixir-ls.png">](img/vscode-elixir-ls.png)


## Type Info

[<img src="img/vscode.png">](img/vscode.png)


## Complile Time Macros

[<img src="img/compile_errors_html.png">](img/compile_errors_html.png)


## Less is More

Removing third party dependencies:

[<img src="img/elixir-in-action.png">](img/vscode.png)
([Elixir In Action](https://www.manning.com/books/elixir-in-action))


## Why not Elixir

* Number crunching
* Small scripts
* Missing library ?


## Why not node ?

* JavasScript Fatigue
* Everyone think they can write JS code
  * mastering JS requires a significant amount of effort
* Immaturity of tooling/poor quality
* Single thread/event loop:
  * Don't block the event loop
  * Async concurrency models


## Random Links

* [Elixir School](https://elixirschool.com/en/)
* [Elixir Lang, getting started](https://elixir-lang.org/getting-started/introduction.html)
* [Hex Package Manager](https://hex.pm/)
* [exercism.io](http://exercism.io/)
* [Pod/Screen casts](https://github.com/elixir-lang/elixir/wiki/Podcasts-and-Screencasts), [The Rabbit Hole](https://www.stridenyc.com/podcasts)
* [Would you still pick Elixir in 2019?](https://github.com/dwyl/learn-elixir/issues/102?utm_source=elixirdigest&utm_medium=email&utm_campaign=featured)
* [Why I'm betting on elixir](https://rossta.net/blog/why-i-am-betting-on-elixir.html)
* [Malmo Elixir Meetup](https://www.meetup.com/Malmo-Elixir/)

[Back](index.html)

