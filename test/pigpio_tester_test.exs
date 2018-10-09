defmodule PigpioTesterTest do
  use ExUnit.Case
  doctest PigpioTester

  test "greets the world" do
    assert PigpioTester.hello() == :world
  end
end
