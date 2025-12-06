defmodule DayFiveTest do
  use ExUnit.Case
  doctest DayFive

  test "parse_fresh" do
    ranges = ["3-5", "10-14", "16-20", "12-18"]
    assert DayFive.parse_fresh(ranges) === [{3, 5}, {10, 14}, {16, 20}, {12, 18}]
  end

  test "compact ranges" do
    assert DayFive.compact_ranges([{3, 5}, {10, 14}, {12, 18}, {16, 20}]) === [{3, 5}, {10, 20}]
  end

  test "p1 demo" do
    str = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32\
    """

    assert DayFive.part1(DayFive.parse(str)) === 3
  end

  test "p2 demo" do
    str = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32\
    """

    assert DayFive.part2(DayFive.parse(str)) === 14
  end

  test "p1 solution" do
    assert DayFive.solve_part1() == 505
  end

  test "p2 solution" do
    assert DayFive.solve_part2() === 344_423_158_480_189
  end
end
