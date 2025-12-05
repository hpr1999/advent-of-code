defmodule DayThreeTest do
  use ExUnit.Case
  doctest DayThree

  test "largest_digit_sequence" do
    assert DayThree.largest_digit_sequence([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 2) ===
             [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1]

    assert DayThree.largest_digit_sequence([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 2) ===
             [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1]

    assert DayThree.largest_digit_sequence([8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9], 2) ===
             [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9]

    assert DayThree.largest_digit_sequence([2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8], 2) ===
             [7, 8]

    assert DayThree.largest_digit_sequence([8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1], 2) ===
             [9, 1, 1, 1, 1, 2, 1, 1, 1]
  end

  test "joltage lines" do
    assert DayThree.joltage(987_654_321_111_111, 2) === 98
    assert DayThree.joltage(811_111_111_111_119, 2) === 89
    assert DayThree.joltage(234_234_234_234_278, 2) === 78
    assert DayThree.joltage(818_181_911_112_111, 2) === 92

    assert DayThree.joltage(987_654_321_111_111, 12) === 987_654_321_111
    assert DayThree.joltage(811_111_111_111_119, 12) === 811_111_111_119
    assert DayThree.joltage(234_234_234_234_278, 12) === 434_234_234_278
    assert DayThree.joltage(818_181_911_112_111, 12) === 888_911_112_111
  end

  test "part one" do
    assert DayThree.solve_p1([
             987_654_321_111_111,
             811_111_111_111_119,
             234_234_234_234_278,
             818_181_911_112_111
           ]) === 357
  end

  test "part two" do
    assert DayThree.solve_p2([
             987_654_321_111_111,
             811_111_111_111_119,
             234_234_234_234_278,
             818_181_911_112_111
           ]) === 3_121_910_778_619
  end

  test "solve part one" do
    assert DayThree.solve_p1() === 17_445
  end

  test "solve part two" do
    assert DayThree.solve_p2() === 173_229_689_350_551
  end
end
