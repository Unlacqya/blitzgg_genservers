defmodule BlitzggTest do
  use ExUnit.Case
  doctest Blitzgg

  test "greets the world" do
    assert Blitzgg.hello() == :world
  end
end
