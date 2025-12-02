defmodule AocElixirTest do
  use ExUnit.Case
  doctest AocElixir

  test "reading files works" do
    Enum.each(1..2, fn num -> AocElixir.read_input(num) end)
  end
end
