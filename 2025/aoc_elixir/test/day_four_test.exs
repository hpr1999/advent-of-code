defmodule DayFourTest do
  use ExUnit.Case
  doctest DayFour

  test "parse_row" do
    assert DayFour.parse_row("..@..", 0) == %{{0, 2} => 1}
  end

  test "parse_grid" do
    assert DayFour.parse_grid([
             "..@..",
             "@...."
           ]) === %{
             {0, 2} => 1,
             {1, 0} => 1
           }
  end

  test "num_filled_neighbours" do
    map =
      DayFour.parse_grid([
        "..@..",
        ".@.@.",
        "..@.."
      ])

    assert DayFour.num_filled_neighbours(map, {1, 2}) === 4
    assert DayFour.num_filled_neighbours(map, {0, 0}) === 1
    assert DayFour.num_filled_neighbours(map, {0, 1}) === 2
  end

  test "num_spots_with_filled_neighbours" do
    map =
      DayFour.parse_grid([
        "..@@.@@@@.",
        "@@@.@.@.@@",
        "@@@@@.@.@@",
        "@.@@@@..@.",
        "@@.@@@@.@@",
        ".@@@@@@@.@",
        ".@.@.@.@@@",
        "@.@@@.@@@@",
        ".@@@@@@@@.",
        "@.@.@@@.@."
      ])

    assert DayFour.num_spots_with_filled_neighbours(map, 3) === 13
  end

  test "remove spots with filled neighbours" do
    map =
      DayFour.parse_grid([
        "..@@.@@@@.",
        "@@@.@.@.@@",
        "@@@@@.@.@@",
        "@.@@@@..@.",
        "@@.@@@@.@@",
        ".@@@@@@@.@",
        ".@.@.@.@@@",
        "@.@@@.@@@@",
        ".@@@@@@@@.",
        "@.@.@@@.@."
      ])

    assert DayFour.remove_spots_with_filled_neighbours(map, 3) === 43
  end

  test "part one" do
    assert DayFour.solve_p1() === 1480
  end

  test "part two" do
    assert DayFour.solve_p2() === 8899
  end
end
