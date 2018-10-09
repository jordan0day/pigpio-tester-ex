# PigpioTester

A test utility similar to [Bypass](https://github.com/PSPDFKit-labs/bypass), but
for [Pigpio](http://abyz.me.uk/rpi/pigpio). I'm using it to test my code which accesses the Pigpio socket interface via [Pigpiox](https://github.com/tokafish/pigpiox).

## Installation

Add `pigpio_tester` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pigpio_tester, git: "https://github.com/jordan0day/pigpio-tester-ex", only: [:test]}
  ]
end
```

## Example

```Elixir
defmodule SimpleWriteTest do
  use ExUnit.Case

  setup do
    {:ok, pigpiod} = PigpioTester.SocketApi.start()
    {:ok, pigpiod: pigpiod}
  end

  test "Sets mode on pin 21 to output", %{pigpiod: pigpiod} do
    PigpioTester.expect(pigpiod, :gpio_set_mode, fn 21, 1 -> :ok end)
  end
end
```




