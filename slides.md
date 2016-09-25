### Developer happiness with Elixir
# Elixir

Andreas Ronge (@ronge)



# Contents

* Introduction
* Language
* Concurrency
* Distributed Elixir
* Tools


## The language

* Operators
* Datatypes
* Functions/Modules
* Pattern Matching
* Comprehension
* Control Flow
* Typespecs
* Behaviours
* Protocols
* Macros


## Concurrency

* Processes, Linking/Trapping
* OTP Server
* OTP Supervisor


## Distributed Elixir

* nodes
* discovery
* multicast, clusters/groups


## Tools

* mix, hex
* exunit, plug
* hot deployment, distillery
* OTP Application



# Introduction


## Why Erlang

Design for:
* Fault-tolerant
* Highly availability
* Hot code replacement
* Self healing network
* Distributed
* Soft real-time


## How

* Functional Programming
* Actor Model (independent discovery)
* OTP patterns, e.g. supervisor behaviour


## Why Elixir

* Make Erlang & tools more accessible
* Meta programming
* Extendable language: Polymorphism
* Pipeline operator
* Fantastic elixir libraries, mix, hex
* Fun !


## Future

* Future of functional programming ?
* What's the future of the JVM ?
* What type of application will we need to build ?
* Fashion and who will we listen to ?
* Syntax matters
* Finding jobs/developers


## Fun driven development

"Change is the only constant"

Let's try new things and have fun


## Resources

* Books
  * [Programming Elixir](https://pragprog.com/book/elixir/programming-elixir)
  * [Elixir in Action](https://www.manning.com/books/elixir-in-action)
* [elixir-lang.org](http://elixir-lang.org/)  
* [exercism.io](http://exercism.io/)
* IEX and elixir docs


## Installation

* `brew install elixir`


## IEX

[<img src="img/iex.png">](img/iex.png)


## inspect

[<img src="img/iex-inspect.png">]


## Hello World

```elixir
IO.puts "Hello"
```


## Compiling

```
iex> c "hello.exs"
iex> import_file "hello.exs"
iex> r HelloWorld
```


## A Convention

* `.ex` files compiles to Erlang
* `.exs` intepreted



# The Language


## Operators


## True and False

* Truth: `true`, `false`, `nil`


* strict: `===`

  `1 === 1.0 is false`

* value equality: `==`

  `1 == 1.0 is true`


## And/Or

* `or`, `and`

  `(1 and 0)` => (ArgumentError) argument error: 1

* `||`,  `&&`, `!`

  `(1 && 0)` => 0


## Operators: ++/--

```elixir
# ++ and -- are List functions
[1,2,3] ++ [4,5]
[1,2,3,4] -- [2,5] # => [1, 3, 4]
```


## String <> operator

To concatenate two Strings
```elixir
"hej" ++ "hopp"
```


## In operator

```elixir
2 in [1,2,3] # => true
x in some_enum
```


## The Pipe Operator

Instead of

```elixir
a = "abc"
b = do_x(a)
c = do_y(b, "foo")
d = do_z(c)
```

Use the pipe operator

```elixir
"abc" |> do_x |> do_y("foo") |> do_z
```


##  Phoenix

```elixir
connection
|> endpoint
|> router
|> pipeline
|> controller
```



# Data Types


## Atoms

Examples:
```elixir
:hej
:"hej"
:<>
FooBar
Hello.Foo
```


## Regular Expressions ~r{}

```elixir
~r[foo]
~r/foo/
~r<foo>
~r(foo)
String.match?("hej hopp", ~r/ho/)
```
~r is a sigil that creates a data type struct


## Tuples

Ordered collection of values

```elixir
{1,2}
{:ok, "Hej", false}
# nested
{:ok, {1, "foo", {true, false}}, [1,2,3]}
```


## List

```elixir
a = [1, 2, "hej", false]
List.first(a)  # not often used !

# Lists can be charlist !
IO.puts "hej #{[49, 50, 51]}"  # =>  hej 123
```


## PIDs

```
iex> i self()
Term
  #PID<0.80.0>
Data type
  PID
Alive
  true
Name
  not registered
Links
  none
Message queue length
  0
Description
  Use Process.info/1 to get more info about this process
Reference modules
  Process, Node
```


## string

Single-quoted and double quoted

* Holds UTF-8 characters
* Escapes sequences, `\n`, `\a`, ...
* Allows interpolation, `#{}` syntax

```elixir
name = "andreas"
IO.puts "Hello #{String.capitalize name}"
```


## Heredoc notation

Strings can span several lines.

```elixir
IO.write """
line 1
line 2
"""
```


## Charlist

```text
iex> i '123'
Term
  '123'
Data type
  List
Description
  This is a list of integers that is printed as a sequence of
  characters delimited by single quotes because all the integers
  in it represent valid ASCII characters. Conventionally, such
  lists of integers are referred to as "charlists" (more
  precisely, a charlist is a list of Unicode codepoints, and ASCII
  is a subset of Unicode).
Raw representation
  [49, 50, 51]
Reference modules
  List
```


## char list

A list of non-negative integers

```elixir
a = 'abc'
# example of list functions available
length a # => 3
Enum.reverse(a) # => 'cba'
'abcd' ++ 'de'
'abcd' -- 'de'
?a # => 97  The ascii code
 ```


## string

```text
iex> i "123"
Term
  "123"
Data type
  BitString
Byte size
  3
Description
  This is a string: a UTF-8 encoded binary.
  It's printed surrounded by "double quotes" because all UTF-8
  encoded codepoints in it are printable.
Raw representation
  <<49, 50, 51>>
Reference modules
  String, :binary
```

```text
byte_size "abc" # => 3
byte_size "ÄÄÄ" : # => 6
length 'ÄÄÄ' # => 3
```


## Sigils

Some more sigils:
```
# A double quoted string
~s[hej "]

# List of whitespace delimited words, no escaping or interpolation
~W<hej hopp x#{}>  

# Dates
~D[2001-01-01]
```


## Exercise

Write something so that
```
* "a,b,c" |> ... # => "c,b,a"
* concatenate two strings
```

(use the `Enum` and `String` modules)


## Answer

```elixir
"a,b,c" |> String.split(",") |> Enum.reverse |> Enum.join
```


## Binaries

```
iex> bit_size(<<0, 1, 2>>)
24

iex> << 1::size(2), 1::size(3) >>
<<9::size(5)>>

iex> bit_size(<<2.5::float>>)
64
```


## Keyword Lists

```text
iex> [{:a, 1}, {:b, 2}]  # Array with tuples
[a: 1, b: 2]  # What ?

iex> [a: 1, b: 2]
[a: 1, b: 2]
```


## Keyword Lists

* Can be used with `Enum` and `Keyword`
* Keys are ordered
* Keys can be given more then once
* Square bracket optional in last arg


## Last argument

can be a keyword list

```elixir
defmodule Foo do                                   
  def foo(x,y), do: IO.puts("x: #{x} y: #{inspect y}")
end
```

```
iex(72)> Foo.foo "hej", a: 2                                 
x: hej y: [a: 2]
```


## Exercise

```
kw = [a: 1, b: 2, c: 3]
```

1. Check if key `:b` is in `kw`
2. Update `c` to 42

(use the Keyword module)


## Answer

```elixir
# 1)
kw = [a: 1, b: 2, c: 3]
Keyword.has_key?(kw, :b)
kw[:b] # access

# 2) Creates a new keyword list
Keyword.put(kw, :b, 42)  
```


## Maps

* Allows any value as a key
* Keys do not follow any ordering
* Useful for pattern matching


## Maps

```
iex> x = %{:foo => 1, 2 => :bar, "hej" => "hopp"}
%{2 => :bar, :foo => 1, "hej" => "hopp"}

iex> x[:foo]
1

iex> x[2]
:bar

iex> x.foo
1

iex> x.qwe
** (KeyError) key :qwe not found in: %{2 => :bar, ...
```


## Map convenience

When all the keys in a map are atoms, you can use the keyword syntax

```
iex> map = %{a: 1, b: 2}
%{a: 1, b: 2}
```


## Exercise

```
x = %{a: 1, foo: 42, bar: "hello"}
```

1. create a list of the keys
2. change `bar` prop to "bye"
3. add a new key and value

(Use the `Map` api)


## More convenience

```
iex(15)> map = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}
iex(16)> map.a    # Strict access (prefer)
1

iex(17)> map.c    # Strict access
** (KeyError) key :c not found in: %{2 => :b, :a => 1}

iex(18)> map[:c]  # Dynamic access
nil

iex(17)> %{map | :a => 2}
%{2 => :b, :a => 2}

iex(18)> %{map | :c => 3}
** (KeyError) key :c not found in: %{2 => :b, :a => 1}
```


## Nested Data

```
iex> users = [
...>   john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
...>   mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
...> ]
[john: %{age: 27, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
 mary: %{age: 29, languages: ["Elixir", "F#", "Clojure"], name: "Mary"}]

iex> users[:john].age
27
```


## Updates

put_in

```
iex)> users = put_in users[:john].age, 31

[john: %{age: 31, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
 mary: %{age: 29, languages: ["Elixir", "F#", "Clojure"], name: "Mary"}]
```


## Exercise

1. Create a list
2. Create a tuple with 2 atoms and 2 charlists
3. Create a Keyword list
4. Create a map with Atom keys
5. Create a map with String keys


## Structs

* A map where all keys must be atom
* Only declared keys are allowed
* Compile time checks


## Example Usage

```elixir
defmodule Person do
  defstruct name: "", age: 0
end
```

```
iex> %Person{}
%Person{age: 0, name: ""}
iex> %Person{name: "Andreas"}
%Person{age: 0, name: "Andreas"}
iex> p = %Person{name: "Andreas"}
%Person{age: 0, name: "Andreas"}
iex> p.age
0
iex> p.qwe
** (KeyError) key :qwe not found in: %Person{age: 0, name: "Andreas"}
```


## Updating Structs

```
iex> me = Map.put(%{Person}, :name, "Andreas")
%Person{age: 0, name: "Andreas"}

iex(36)> %Person{me | name: "you"}
%Person{age: 0, name: "you"}

```


## Compile time checks

```elixir
defmodule User do
  defstruct name: "", age: 0
end

defmodule UserRepo do
  def create_user(name), do: %User{nam2e: name}
end
```

```
== Compilation error on file struct.ex ==
** (KeyError) key :nam2e not found in: %User{age: 0, name: ""}
    (stdlib) :maps.update(:nam2e, {:name, [line: 6], nil}, %User{age: 0, name: ""})
    struct.ex:2: anonymous fn/2 in User.__struct__/1
    (elixir) lib/enum.ex:1623: Enum."-reduce/3-lists^foldl/2-0-"/3
    expanding struct: User.__struct__/1
    struct.ex:6: UserRepo.create_user/1
```


## Exercise

```
%Plug.Conn{host: "www.example.com",
           path_info: ["bar", "baz"]}

```

* Create the struct
* Create an instance with the data above
* Update host to "foo.com"
* Add "foobar" to `path_info`


## Answer

```elixir
defmodule Plug.Conn do
  defstruct host: "", path_info: []
end

conn = %Plug.Conn{host: "www.example.com", path_info: ["bar", "baz"]}
%{conn | host: "foo.com"}
put_in conn.path_info, conn.path_info ++ ["foobar"]
```



# Functions/Modules


## Anonymous functions

```
iex> sum = fn (a, b) -> a + b end
#Function<12.52032458/2 in :erl_eval.expr/5>

iex> sum.(1,2) # Notice the dot !
3
```


## Closures

```
x = 1
sum = fn y -> x + y end
sum.(2) #=> 3
```


## Modules

```elixir
defmodule MyModule do
  def sum(x, y) do
    x + y
  end

  # oneliner, notice similarity to keyword list
  def add_one(x), do: sum(x, 1)  # No dot needed
end
```

```
iex> MyModule.add_one(42)
```


## Exercise

Create the `silly` function so that

```elixir
f = fn (x) -> x * 2 end

42 |> MyModule.silly(f) # "x: 84"
```


## Answer

```elixir
defmodule MyModule do                      
  def silly(val, fun), do: "x: #{fun.(val)}"
end
```


## import

* Not needed
* Allows using without fully-qualified name.

```
iex> import MyModule
iex> add_one(2)
```

(`require` is for macros)


## import scope

```elixir
defmodule Example do
  def func1 do
    List.flatten [1,[2,3],4]
  end

  def func2 do
    import List, only: [flatten: 1]
    flatten [5,[6,7],8]
  end
end
```


## Conventions

* `?` postfix returns false/true

  Example: `String.contains?/2`
* `!` postfix may throw exception

  Example: `File.open!/1`

* snake_case atoms, functions, variables and files.


## Nested Modules
and file location

```
lib
|-- ecto
|   |-- adapter
|   |   |-- migration.ex
```

```elixir
defmodule Ecto.Adapter.Migration  do
  # ...
end
```


## Function Refs

```
iex> a_func = &MyModule.add_one/1
&MyModule.add_one/1
iex> a_func.(2)

iex> l = &length/1
&:erlang.length/1
 ```


## Function shortcuts

```
iex(32)> sum = &(&1 + &2)
&:erlang.+/2   # <----- !!!!

iex(33)> sum.(1,2)
3
```


## Function returning function

```
iex> add_n = fn n -> (fn other -> n + other end) end
#Function<6.52032458/1 in :erl_eval.expr/5>

iex> add_two = add_n.(2)
#Function<6.52032458/1 in :erl_eval.expr/5>

iex> add_two.(3)
5

```


## Exercises

* A) Use `Enum.map` to make

   `[1,2,3] |> ___ => [2,3,4]`

* B) Write a function that takes a function so that

  `a_function.(fn -> "hej" end)`
  returns: "hej hopp"


## Solutions

```elixir
# A)
[1,2,3] |> Enum.map(&(&1 + 1))

# B)
a_function = fn(f) -> "#{f.()} hopp" end
```


## Module attributes

```elixir
defmodule Example do
  @author "Andreas"
  def get_author do
    @author
  end
end

IO.puts "Example was written by #{Example.get_author}"
```



# Pattern Matching


## Simple values

```
iex> 1 = 1
1
iex> 1 = 0
** (MatchError) no match of right hand side value: 0

iex> 3 = x
3
iex> 4 = x
** (MatchError) no match of right hand side value: 3
iex> x = 4
4

iex> ^x = 4
4
iex> ^x = 5
** (MatchError) no match of right hand side value: 5
```


## Tuples

```
iex(1)> {a, b} = {1,2}
{1, 2}
iex(2)> {a, b} = {b, a}
{2, 1}
iex(3)> {x, _} = {{1,true}, "foo"}
{{1, true}, "foo"}
iex(4)> {{1, flag}, "foo"} =  {{1,true}, "foo"}
{{1, true}, "foo"}
iex(5)> flag
true
iex(6)> {q={1, flag}, "foo"} =  {{1,true}, "foo"}
{{1, true}, "foo"}
iex(7)> q
{1, true}
```


## Tuples Practical Examples

```
iex> {status, file} = File.open("mix.exs")
{:ok, #PID<0.83.0>}

iex> {:ok, file} = File.open("mix.exs")   
{:ok, #PID<0.85.0>}
```


## Arrays

```
list = [1, 2, 3]
[a, b, c ] = list   # Ok, a = 1, b = 2, c = 3
[a, 2, b ] = list   # OK
[a, 3, b ] = list   # Match Error
[a, b, c] = [1, [2, 3], 4]
[a, [b, _], c] = [1, [2, 3], 4]  # _ = I don’t care
```


## Exercises

Which will match when `x = 4` ?
1. `[a, b, a] = [1, 2, 3]`
2. `[a, b, a] = [1, 2, 1]`
3. `[_, b, a] = [1, 2, 3]`
4. `[a, b] = [1, 2, 3]`
5. `[a, b, c] = [1, 2]`
6. `[x, b, c] = [1, 2, 3]`
7. `[^x, b, c] = [1, 2, 3]`


## Append to array

```
[9 | [1,2,3]] # =>  [9,1,2,3]
```


## Strings
(binaries)

```elixir
"hej" <> hopp  = "hejhopp"
[h| t] = to_char_list("abcd")
```


## Head and Tails

```
iex> a = [1,2,3,4]
[1, 2, 3, 4]
iex> [h | t] = a
[1, 2, 3, 4]
iex> h
1
iex> t
[2, 3, 4]
```


## More heads

```
iex> [h1, h2 | t] = a
[1, 2, 3, 4]
iex> h1
1
iex> h2
2
iex> t
[3, 4]
```


## Pattern Matching Heads

```
iex> [t1, 2 | t] = a
[1, 2, 3, 4]

iex> [t1, 3 | t] = a
** (MatchError) no match of right hand side value: [1, 2, 3, 4]
```


## Heads with nested data

```
iex> icecreams = [{"cookies", 5}, {"chocolate", 3}, {"mint", 4}]
iex> [{name, _} | _] = icecreams
[{"cookies", 5}, {"chocolate", 3}, {"mint", 4}]
iex> name
"cookies"
```


# with

Combines matching clauses.

```
iex> opts = %{width: 10, height: 15}
iex> with {:ok, width} <- Map.fetch(opts, :width),
...>      {:ok, height} <- Map.fetch(opts, :height),
...>   do: {:ok, width * height}
{:ok, 150}
```


## Advanced pattern matching

What does this do ?
[PragProg Example](https://media.pragprog.com/titles/elixir/lists.pdf)

```elixir
def for_location([ head = [_, target_loc, _, _ ] | tail], target_loc) do
 [ head | for_location(tail, target_loc) ]
end
```


## List and Recursion

```elixir
defmodule MyList do
  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail)
end
```


## Keyword List

Rarely done since pattern matching on lists requires the number of items and their order to match

```
iex> [a: a] = [a: 1]
[a: 1]
```


## Maps

```
iex> %{:a => a} = %{:a => 1, 2 => :b}
%{2 => :b, :a => 1}

iex> a
1

iex> %{:c => c} = %{:a => 1, 2 => :b}
** (MatchError) no match of right hand side value: %{2 => :b, :a => 1}
```


## Exercises, Destructing

Example:
Set `a = :bar` from `{:foo, :bar}`

Solution: `{_, a} = {:foo, :bar}`

* a) Set `a=:b` from  `[{:a,:b,:c}]`
* b) Set `a=4` from  `[[1,2], [3,4]]`
* c) Set `a=4` and `b=[3,4]` from `[[1,2], [3,4]]`
* d) Set `a="kalle"` from `[{3, %{name: "kalle"}}]`


## Answers

```elixir
# a)
[{_,a,_}] = [{:a,:b,:c}]

# b)
[_, [_, a]] = [[1,2], [3,4]]

# c)
[_, b=[_,a]] = [[1,2], [3,4]]

# d)
[{_, %{name: a}}] = [{3, %{name: "kalle"}}]  
```


## Functions args

```elixir
defmodule Fib do
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do fib(n-1) + fib(n-2) end
end
```


## Nested function args

```
iex> f = fn({_, price}) -> price end
iex> f.({"vanilla", 3})             
3

iex> icecreams = [{"cookies", 5}, {"chocolate", 3}, {"mint", 4}]
[{"cookies", 5}, {"chocolate", 3}, {"mint", 4}]
iex> first_name.(icecreams)
"cookies"
```


## Function with multiple bodies

```
iex> handle_open = fn
...> {:ok, file} -> "Read #{IO.read(file, :line)}"
...> {_, error} -> "Error: #{:file.format_error(error)}"
...> end
#Function<6.52032458/1 in :erl_eval.expr/5>

iex(6)> handle_open.(File.open("notexist.txt"))
"Error: no such file or directory"
```


## Exercises 1

Create a function: that returns the total price of all ice creams.
Use `Enum` functions

```
icecreams = [{"cookies", 5}, {"chocolate", 3}, {"mint", 4}]
```


## Solutions 1

```elixir
icecreams |> Enum.map(fn({_, price}) -> price end) |> Enum.sum
```


## Exercises 2, recursive

Do not use `Enum`, use recursion

* Return the length of the array
* Get the total price of all ice creams

```
icecreams = [{"cookies", 5}, {"chocolate", 3}, {"mint", 4}]
```

(Erlang has tail call optimization)


## Guards

```elixir
defmodule Guard do
  def what_is(x) when is_number(x) do
    IO.puts "#{x} is a number"
  end

  def what_is(x) when is_list(x) do
    IO.puts "#{inspect(x)} is a list"
  end

  def what_is(x) when is_atom(x) do
    IO.puts "#{x} is an atom"
  end
end
Guard.what_is(99) # => 99 is a number
Guard.what_is(:cat) # => cat is an atom
Guard.what_is([1,2,3]) # => [1,2,3] is a list
```



# Comprehension


## Examples

```
iex> for n <- [1, 2, 3, 4], do: n * n
[1, 4, 9, 16]

iex> values = [good: 1, good: 2, bad: 3, good: 4]
[good: 1, good: 2, bad: 3, good: 4]

iex> for {:good, n} <- values, do: n * n
[1, 4, 16]

iex> multiple_of_3? = fn(n) -> rem(n, 3) == 0 end
#Function<6.52032458/1 in :erl_eval.expr/5>

iex> for n <- 0..5, multiple_of_3?.(n), do: n * n
[0, 9]
```


## into

```elixir
for {key, val} <- %{"a" => 1, "b" => 2}, into: %{}, do: {key, val * val}
%{"a" => 1, "b" => 4}
```



# Control Flow


## case, example 1

```elixir
case {1, 2, 3} do
 {1, x, 3} when x > 0 -> "Will match"
 _ ->  "Would match, if guard condition were not satisfied"
end
```

## case, example 2

```elixir
case :gen_tcp.connect 'localhost', 8001, [] do
  {:ok, pid } -> pid
  {:error, reason} -> handle_error(reason)
end
```


## cond

Find first  conditions that evaluates to true.

```
iex> cond do
...>   2 + 2 == 5 ->
...>     "This will not be true"
...>   2 * 2 == 3 ->
...>     "Nor this"
...>   1 + 1 == 2 ->
...>     "But this will"
...> end
"But this will"
```


## if and unless
a macro : [Kernel.if](http://elixir-lang.org/docs/stable/elixir/Kernel.html#if/2)

```
iex> if nil do
...>   "This won't be seen"
...> else
...>   "This will"
...> end
"This will"
```


## if and unless, short

```
if(foo, do: bar, else: baz)
if true, do: 2, else: 4
```



# Stream module

Similar to Enum but supports lazy operations.



# Typespecs

* Used as documentation and for the Dialyzer tool
* Static analysis of code
* Extends the Erlang syntax


## Attributes

* `@type`
* `@opaque`
* `@typep`
* `@spec`
* `@callback`
* `@macrocallback`


## Basic Type

Examples, type ::
* `any`
* `none`
* `pid`
* `atom`
* `integer`
* `pos_integer`


## Literals

Examples, type ::
* 1
* 1..10
* [type] # list of type
* [] empty list
* (type1, type2 -> type)  # function
* {:ok, type}  


## Module Types

Example:
* Range.t
* Enum.t
* String.t


## Defining type

* Syntax:

  `@type type_name :: type`

* Example

  `@type mytype :: 1..30 | atom`

  `@type dict(key, value) :: [{key, value}]`


## Specs

* Syntax:

  `@spec function_name(type1, type2) :: return_type`


## Example

```elixir
defmodule LousyCalculator do
  @typedoc """
  Just a number followed by a string.
  """
  @type number_with_remark :: {number, String.t}

  @spec add(number, number) :: number_with_remark
  def add(x, y), do: {x + y, "You need a calculator to do that?"}

  @spec multiply(number, number) :: number_with_remark
  def multiply(x, y), do: {x * y, "It is like addition on steroids."}
end
```


## Dialyzer

* Static analysis tool
* analyze the BEAM files
* can be useful even without @specs
* Persistent Lookup Table


## Running Dialyzer

```elixir
def run, do: some_op(5, :you)
def some_op(a,b), do: a + b
```


## Output

```
typeexample (master) $ mix dialyzer
Starting Dialyzer
dialyzer --no_check_plt --plt /Users/andreasronge/.dialyxir_core_19_1.3.2.plt -Wunmatched_returns -Werror_handling -Wrace_conditions -Wunderspecs /Users/andreasronge/projects/elixir/presentation/dev-happiness-elixir/typespecs/typeexample/_build/dev/lib/typeexample/ebin
  Proceeding with analysis...
typeexample.ex:3: Function run/0 has no local return
typeexample.ex:3: The call 'Elixir.Typeexample':some_op(5,'you') will
never return since it differs in the 2nd argument from the success
typing arguments: (number(),number())
 done in 0m1.35s
done (warnings were emitted)

```


## Conventions

```elixir
defmodule User do
  defstruct [:name, :email]
  @type t :: %__MODULE__{name: String.t, email: String.t}
end

defmodule OtherModule do
  @spec find_user(String.t) :: User.t
  def find_user(user), do: User%{name: "kalle"}
end
```



# Behaviours

* A list of functions
* Compile time checked
* Similar to Java interfaces
* Defined with @callback
* Abstract generic functionalities


## Dynamic Invocation

```
iex> x = IO
IO
iex> x.puts "HEJ"
HEJ
:ok
iex> apply(IO, :puts, ["hej"])
hej
:ok
```

MFA - module, function, arguments list


## Example

```elixir
defmodule Greeter do
  @callback say_hello(String.t) :: any
  @callback say_goodbye(String.t) :: any
end
defmodule NormalGreeter do
  @behaviour Greeter
  def say_hello(name), do: IO.puts "Hello, #{name}"
  def say_goodbye(name), do: IO.puts "Goodbye, #{name}"
end
defmodule HelloAll do
  def hello_to_all(greeters) do
    greeters |> Enum.each(& &1.say_hello("andreas"))
  end
end

HelloAll.hello_to_all([NormalGreeter])
```



# Protocols
Polymorphism in Elixir
Extending external modules


## defprotocol

To define a new
```elixir
defprotocol Blank do
 @doc "Returns `true` if `data` is considered blank/empty"
 def blank?(data)
end
```


## defimpl

For each type we need to define implementations

```elixir
defimpl Blank, for: Integer do
 def blank?(number), do: false
end

# The only blank list is the empty one
defimpl Blank, for: List do
 def blank?([]), do: true
 def blank?(_),  do: false
end
```


## Extending Existing Protocols

The Collectable Protocol

```elixir
Enum.into([1,2,3], %{}, &({&1,&1*2}))
%{1 => 2, 2 => 4, 3 => 6}

# or
for {x,y} <- %{a: 1, b: 2, c: 3}, into: %{}, do: {x, y+1}
%{a: 2, b: 3, c: 4}
```


## Collectable.into

```
def into(collectable)                              

Returns a function that collects values alongside the initial
accumulation value.

The returned function receives a collectable and injects a
given value into it for every {:cont, term} instruction.

:done is passed when no further values will be injected, useful
for closing resources and normalizing values.
A collectable must be returned on :done.

If injection is suddenly interrupted, :halt is
passed and it can return any value, as it won't be used.
```


## API

```elixir
defprotocol Collectable do
  @type command :: {:cont, term} | :done | :halt

  @spec into(t) :: {term, (term, command -> t | term)}
  def into(collectable)
end
```


## Implementation, for Map

```elixir
defimpl Collectable, for: Map do
  # @type command :: {:cont, term} | :done | :halt
  # @spec into(t) :: {term, (term, command -> t | term)}
  def into(original) do
    {original, fn
      map, {:cont, {k, v}} -> :maps.put(k, v, map)
      map, :done -> map
      _, :halt -> :ok
    end}
  end
end
```



# Macros


## Example

```elixir
defmodule Hello do
  defmacro hello_macro do
    quote do
      def say_hello do
        IO.puts "Hello"
      end
    end
  end
end

defmodule MyModule do
  require Hello
  Hello.hello_macro
end

MyModule.say_hello
```


## using

`use` calls `__using__` macro

```elixir
defmodule HelloLibrary do  
  defmacro __using__(_) do
    quote do
      def say_hello, do: IO.puts("Hello")
    end
  end
end
```


## Usage
Using `__using__`

```elixir
defmodule MyModule do
  use HelloLibrary
end

MyModule.say_hello
```


### Using and Behaviour

```elixir
defmodule GenServer do
  defmacro __using__(_) do  
    quote do
      @behaviour :gen_server
```

GenServer module calls your callbacks.



# Concurrency


## Processes

* all code runs inside processes
* actor model: message passing, share nothing
* extremely lightweight
* takes advantage of a multi-core or multi-CPU computer
* each process has a private heap that is garbage collected independently
* preemptive scheduling


## I/O Calls

* the calling process is preempted
* A separate async threads


(source [Erlang Factory](http://www.erlang-factory.com/upload/presentations/105/KennethLundin-ErlangFactory2009London-AboutErlangOTPandMulti-coreperformanceinparticular.pdf))

[<img src="img/erlang-smp.png">](img/erlang-smp.png)


## Creating a new process

* `spawn((() -> any)) :: pid`
* `spawn(module, atom, list) :: pid`
* `spawn_link(module, atom, list) :: pid`
* `spawn_monitor((() -> any)) :: {pid, reference}`


## Sending

* send is asynchronoues
* send a message to a mail box

```
iex> send self(), "hello world"
"hello world"
iex> flush # empty and checks what's in the mail box
"hello world"
```


## receive

* Each process has a mail box
* in receive block:
* * messages are removed if matched
* * unmatched messages are retried later
* * none matching message suspends the process
* * timeout can be specified


## Example

```elixir
current = self()
child   = spawn(fn -> send current, {self(), 3} end)

receive do
   {^child, x} -> IO.puts "Received #{x} back"
end
```


## How keep process alive

we want to send another message

```
iex> Process.alive? child
```


## Calculate Area

```elixir
defmodule Area do
  def loop() do
    receive do
      {from, {:rectangle, w, h}} ->
        send(from, w * h)
        loop()  # This is how keep it alive
      _ -> IO.puts "Unknown message"
    end
  end
end
```

```
iex> pid = spawn(Area, :loop, [])
iex> send(pid, {self(), {:rectangle, 2,3}})
iex> flush
```


## Exercise

Create a process that holds state so that:

```
iex> pid = spawn(MyState, :loop, [%{bar: "foo"}])
iex> send(pid, {:get, :bar})
iex> flush
"foo"
iex> send(pid, {:set, :bar, "baaz"})
iex> send(pid, {:get, :bar})
iex> flush
"baaz"
```


## Solution

```elixir
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
```


## Agents

```
iex> {:ok, agent} = Agent.start_link fn -> [] end
{:ok, #PID<0.57.0>}
iex> Agent.update(agent, fn list -> ["eggs" | list] end)
:ok
iex> Agent.get(agent, fn list -> list end)
["eggs"]
iex> Agent.stop(agent)
:ok
```

Why keeping state in a separate process ?


## Tasks

```elixir
task = Task.async(fn -> do_some_work() end)
res  = do_some_other_work()
res + Task.await(task)
```


## Exit Signals

* Normal exit, normally ignored (reason: `:normal`)
* Unhandled Error (e.g. matching error)
* Killed (another process sends exit with reason `:kill`)


## Linking

* If two processes are linked then they will receive the others exit signal

* If the exit reason is not `:normal`, all the processes linked to the process that
exited will crash (unless they are trapping exits).


```elixir
defmodule Crash do
  def start_link, do: spawn_link(__MODULE__, :loop, [])
  def ohh(pid), do: send(pid, :ohh)

  def loop do
    receive do
      :ohh -> throw "Ohh"
    end
  end
```

```
iex> p = Crash.start_link
iex> Crash.ohh(p)
** (EXIT from #PID<0.80.0>) an exception was raised:
** (ErlangError) erlang error: {:nocatch, "Ohh"}
    crash.ex:21: Crash.loop/0

20:29:22.708 [error] Process #PID<0.157.0> raised an exception
(ErlangError) erlang error: {:nocatch, "Ohh"}
    crash.ex:21: Crash.loop/0
Interactive Elixir (1.3.2) - press Ctrl+C to exit (type h() ENTER for help)
```


## Trapping exists

```
iex> Process.flag(:trap_exit, true)
iex> p = Crash.start_link
iex> Crash.ohh(p)
iex>
20:37:36.700 [error] Process #PID<0.165.0> raised an exception
** (ErlangError) erlang error: {:nocatch, "Ohh"}
    crash.ex:21: Crash.loop/0
iex> flush
{:EXIT, #PID<0.165.0>,
 {{:nocatch, "Ohh"}, [{Crash, :loop, 0, [file: 'crash.ex', line: 21]}]}}
```


## Exercise, trapping

```elixir
receive do
	:hi -> loop
	:bye -> IO.puts "Bye"
	:ohh -> throw "Ohh"
end
```

What exit reason when sending ?
* `:bye`
* `:ohh`
* `:hi`
* Process.exit(pid, :bla)
* Process.exit(pid, :kill)


## Exercise, Observer

```
iex> :observer.start
```

* Find the Crash process
* Send some unknown messages
* Find the unknown messages



# What is OTP ?

* Included in Erlang/Elixir
* Framework to build fault-tolerant,scalable apps
* Debuggers, profilers, databases etc...



# OTP: GenServer

* Generic part - behaviour
* Specific part - callback modules


## OTP behaviours

* `:gen_server` stateful server process
* `:supervisor` recovery
* `:application` components/libraries
* `:gen_event` event handling
* `:gen_fsm` - finite state machine


## Common needs

A stateful server process:
* Spawn a new process
* Run a loop
* Maintain process state
* React to messages
* Send response back


## GenServer Callbacks

* init/1
* terminate/2
* handle_call/3
* handle_cast
* handle_info
* code_change/3


## GenServer Module

* GenServer.start -> init/1
* GenServer.start_link -> init/1
* GenServer.stop -> terminate/2
* GenServer.call -> handle_call/3
* GenServer.cast -> handle_cast/2


## GenServer.handle_call/3

* Args: request, caller pid, state
* Returns: `{:reply, response, new_state}`

```elixir
# API
def pop(pid) do
  GenServer.call(pid, :pop) # Sync !
end

# Callback
def handle_call(:pop, _from, [h | t]) do
  {:reply, h, t}
end
```


## GenServer.handle_cast/2

* Args: request, state
* Returns: {:no_reply, new_state}

```elixir
# API
def push(pid, data) do
  GenServer.cast(pid, {:push, data}) # ASync !
end

# Callback
def handle_cast({:push, h}, t) do
  {:noreply, [h | t]}  # Async !
end
```


## OTP GenServer

```elixir
defmodule MyStack do
  use GenServer # thin wrapper around OTP's :gen_server

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def push(pid, data) do
    GenServer.cast(pid, {:push, data}) # ASync !
  end

  def pop(pid) do
    GenServer.call(pid, :pop) # Sync !
  end

  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
```


## Usage

```
iex> {_, pid} = MyStack.start_link([])
{:ok, #PID<0.94.0>}
iex> MyStack.push(pid, 42)
:ok
iex> MyStack.push(pid, 43)
:ok
iex> MyStack.pop(pid)
43
```


## Register PID

```elixir
defmodule MyStack.Server do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def push(data) do
    GenServer.cast(__MODULE__, {:push, data}) # ASync !
  end

  def pop() do
    GenServer.call(__MODULE__, :pop) # Sync !
  end

  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
```


## Let it crash

```
iex> MyStack.pop(pid)
42
iex> MyStack.pop(pid)
** (EXIT from #PID<0.80.0>) an exception was raised:
iex> MyStack.pop(pid)
** (CompileError) iex:2: undefined function pid/0  
```

What happened ?



# OTP supervisors


## Supervisor

* Manages one or more worker processes or supervisors
* Handles process exits, e.g. with a restart
* Impl. the GenServer behaviour


## callbacks

* `init/1` - returns a supervisor specification of child processes to supervise


## worker

`Supervisor.Spec.worker/3`

```elixir
children = worker(MyStack, [[]])
```

Will start Todo by calling `start_link` with one argument []


## Strategies

```
supervise(children, strategy: :one_for_one)
```

* `:one_for_one` - If a child process terminates, only that process is restarted.
* `:one_for_all`, `:rest_for_one`, `:simple_one_for_one`


## Example

```elixir
defmodule MyStack.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
    # will call init with nil as argument
  end

  def init(_) do
    children = [
      worker(MyStack.Server, [["initial value"]])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
```


## children

Register pid with an alias

```elixir
defmodule MyStack.Server do
  use GenServer

  def start_link(state) do             # Register a pid with an alias
    d#                                           |
    GenServer.start_link(MyStack.Server, state, name: MyStack.Server)
  end

  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
```


## Full Example

```elixir
defmodule MyStack.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
    # will call init with nil as argument
  end

  def init(_) do
    children = [
      worker(MyStack.Server, [["initial value"]])
    ]
    supervise(children, strategy: :one_for_one)
  end
end

defmodule MyStack do
  def start do
    MyStack.Supervisor.start_link
  end

  def push(data) do
    GenServer.cast(MyStack.Server, {:push, data}) # ASync !
  end

  def pop() do
    GenServer.call(MyStack.Server, :pop) # Sync !
  end
end

defmodule MyStack.Server do
  use GenServer

  def start_link(state) do
    GenServer.start_link(MyStack.Server, state, name: MyStack.Server)
  end

  def handle_call(:pop, _from, [h | t]), do: {:reply, h, t}
  def handle_cast({:push, h}, t), do: {:noreply, [h | t]}
end
```


## Multiple Children

* How to get PIDs ?
(registered alias does not work)

* Process Registry (gproc)
  * A supervisor for a pool of worker


## Riak Supervisor Tree

[<img src="img/supervision-tree.png">](img/supervision-tree.png)



# Distributed Elixir


## Nodes

Connecting nodes to clusters

```
iex --sname foo@localhost
iex(foo@localhost)> Node.connect :bar@localhost
true
iex(foo@localhost)2> Node.list
[:bar@localhost]
```

```
 iex --sname bar@localhost
```


## Remote shell

```
 iex --sname baz --remsh foo@HOST
 # for more info:
 iex> h(IEx)
```


## Via LAN

Need shared cookie

```
iex --name one@192.168.0.42 --cookie secret
```


## Spawn

```
iex(foo@localhost)> Node.list
[:bar@localhost]
iex(foo@localhost)> called = self  # using closure
#PID<0.86.0>
iex(foo@localhost)> Node.spawn(:bar@localhost,
	fn -> send(called, {:response, "Hi"}) end)
#PID<8914.92.0>  # Different PID !
iex(foo@localhost)> flush
{:response, "Hi"}
```

Use MFA (module, function argument list) instead of lambdas


## Monitoring nodes

`:net_kernel.monitor_nodes/1,2`
TODO


## Global Registration

Todo

```global.register_name```  cluster wide alias

GenServer.start_link, name: {:global, :some_alias}


## Process Groups

* Multiple redundant processes
* `GenServer.multi_call` to update all



# Tools/Apps

* Debugging
* OTP Applications
* Mix/Hex
* Plug
* ExUnit
* Deployment with distillery


## Debugging

* IEx.pry
* :debugger.start()
* More info [here](http://blog.plataformatec.com.br/2016/04/debugging-techniques-in-elixir-lang/)


## OTP Applications

```
Application controller
   |          |      |
  App1	    App2    App3
   |          |      |
Supervisor1   Sup2   Sup3
```

(erlang)

`:application.start(:my_plug)`


## Library Applications


## Mix File

```elixir
defmodule MyPlug.Mixfile do
  use Mix.Project

  def project do  # Description of the project
    [ app: :my_plug, version: "0.2.1", elixir: "~> 1.3", ...
     deps: deps()]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:logger, :cowboy, :plug], # Runtime deps  
      mod: {MyPlug, []} # The Application OTP Behaviour
    ]
  end

  def deps: ...  # compile time deps
```


## OTP Application

```elixir
defmodule MyApp do
  use Application

  def start(_type, _args) do
    MyApp.Supervisor.start_link()
  end
end
```


## Why

* Reusable components
* Configure without recompile
* Runtime dependencies
* Automatic start


## Application Configuration

```
# mix file:
def application do [
  ...
  env: [port: 5454]  # default
]
```

or just
```
iex --erl "myplug port 5454" -S mix
# see also Application.get_env/2
```


## Mix

Generate a new project

```
mix new my_plug
cd my_plug
```


## Add a dependency

Edit `mix.exs`

Add:

```
def application do
  [applications: [:cowboy, :plug]]
end

def deps do
  [{:cowboy, "~> 1.0.0"},
   {:plug, "~> 1.0"}]
end
```


## Download

```
mix deps.get
mix deps.compile
# or just: mix do deps.get, compile
```


## Hex

The package manager for the Erlang ecosystem
(can be used with rebar3 erlang build tool)

http://hex.pm](https://hex.pm/)


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
