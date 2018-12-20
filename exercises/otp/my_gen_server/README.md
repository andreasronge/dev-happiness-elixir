# MyGenServer


Usage:

```
mix -S mix
iex> {:ok, pid} = MyGenServer.start_link(FooServer, [])
iex> MyGenServer.call(pid, :say_hello) # => "Hello"
iex> MyGenServer.call(pid, :say_goodbye) # => "Bye bye"
```

Or mix test