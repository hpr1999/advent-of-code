defmodule DayTenTest do
  use ExUnit.Case
  doctest DayTen
  import DayTen

  test "demo p1" do
    input =
      String.split(
        """
        [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
        [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
        [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}\
        """,
        "\n"
      )

    assert parse(input) |> part1() === 7
  end

  test "solve p1" do
    assert parse() |> part1() === 509
  end
end
