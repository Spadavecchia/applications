defmodule ApplicationsTest do
  use ExUnit.Case
  doctest Applications

  test "greets the world" do
    assert Applications.hello() == :world
  end
end
