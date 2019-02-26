defmodule ApplicationsTest do
  use ExUnit.Case
  doctest Applications

  test "create files into storage" do
    assert Applications.hello() == :world
  end
end
