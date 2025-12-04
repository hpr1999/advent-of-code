defmodule DayThreeTest do
  use ExUnit.Case
  doctest DayThree

  test "find_max_trail" do
    assert DayThree.find_max_digit_with_trail(987_654_321_111_111) ===
             [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1]

    assert DayThree.find_max_digit_with_trail(811_111_111_111_119) ===
             [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9]

    assert DayThree.find_max_digit_with_trail(234_234_234_234_278) ===
             [7, 8]

    assert DayThree.find_max_digit_with_trail(818_181_911_112_111) ===
             [9, 1, 1, 1, 1, 2, 1, 1, 1]
  end

  test "joltage lines" do
    assert DayThree.calc_joltage(987_654_321_111_111) === 98
    assert DayThree.calc_joltage(811_111_111_111_119) === 89
    assert DayThree.calc_joltage(234_234_234_234_278) === 78
    assert DayThree.calc_joltage(818_181_911_112_111) === 92
  end

  test "sum joltage" do
    assert DayThree.sum_joltages([
             987_654_321_111_111,
             811_111_111_111_119,
             234_234_234_234_278,
             818_181_911_112_111
           ]) === 357
  end
end
