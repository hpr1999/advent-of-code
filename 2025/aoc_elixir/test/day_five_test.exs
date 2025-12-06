defmodule DayFiveTest do
  use ExUnit.Case
  doctest DayFive

  test "parse_fresh" do
    ranges = ["3-5", "10-14", "16-20", "12-18"]
    assert DayFive.parse_fresh(ranges) === [{3, 5}, {10, 14}, {12, 18}, {16, 20}]
  end

  test "compact ranges" do
    assert DayFive.compact_ranges([{3, 5}, {10, 14}, {12, 18}, {16, 20}]) === [{3, 5}, {10, 20}]
  end

  test "solve p1" do
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

    assert DayFive.solve_p1(str) === 3
  end

  test "solve p2" do
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

    assert DayFive.solve_p2(str) === 14
  end

  test "p1 solution" do
    DayFive.solve_p1(AocElixir.read_input(5)) === 505
  end

  test "p2 solution" do
    DayFive.solve_p2(AocElixir.read_input(5)) === 344_423_158_480_189
  end
end
