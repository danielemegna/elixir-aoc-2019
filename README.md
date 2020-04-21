# Elixir Advent of Code 2019

Solutions for https://adventofcode.com/2019 in elixir-lang (https://elixir-lang.org/)

## Run

Get dependencies and run tests with
```
$ mix deps.get
$ mix test
```

Challenge solutions are in tests as assertions:

```elixir
defmodule Advent1Test do
  use ExUnit.Case

  test "resolve level" do
    assert Advent1.resolve == 3262358
  end

end

```
