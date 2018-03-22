defmodule TestMe2Test do
  use ExUnit.Case
  doctest TestMe2

  test "greets the world" do
    assert TestMe2.hello() == :world
  end
end
