defmodule DayNineTest do
  use ExUnit.Case
  doctest DayNine
  import DayNine

  defp demo_input() do
    [
      {7, 1},
      {11, 1},
      {11, 7},
      {9, 7},
      {9, 5},
      {2, 5},
      {2, 3},
      {7, 3}
    ]
  end

  test "demo p1" do
    assert demo_input() |> part1() === 50
  end

  test "solve p1" do
    assert solve_part1() === 4_759_531_084
  end
end
