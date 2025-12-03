defmodule DayTwoTest do
  use ExUnit.Case
  doctest DayTwo

  test "finds invalid id part one" do
    assert DayTwo.is_invalid_id_part_one("55")
    assert DayTwo.is_invalid_id_part_one("6464")
    assert DayTwo.is_invalid_id_part_one("123123")

    assert not DayTwo.is_invalid_id_part_one("5")
    assert not DayTwo.is_invalid_id_part_one("64")
    assert not DayTwo.is_invalid_id_part_one("123")
    assert not DayTwo.is_invalid_id_part_one("101")

    assert DayTwo.is_invalid_id_part_one(55)
    assert DayTwo.is_invalid_id_part_one(6464)
    assert DayTwo.is_invalid_id_part_one(123_123)

    assert not DayTwo.is_invalid_id_part_one(5)
    assert not DayTwo.is_invalid_id_part_one(64)
    assert not DayTwo.is_invalid_id_part_one(123)
    assert not DayTwo.is_invalid_id_part_one(101)
  end

  test "split_in_middle" do
    assert DayTwo.split_in_middle("55") === {"5", "5"}
    assert DayTwo.split_in_middle("64") === {"6", "4"}
    assert DayTwo.split_in_middle("6464") === {"64", "64"}
  end

  test "split multiple" do
    assert DayTwo.split_multiple("123456", 1) === ["1", "2", "3", "4", "5", "6"]
    assert DayTwo.split_multiple("123456", 2) === ["12", "34", "56"]
    assert DayTwo.split_multiple("123456", 3) === ["123", "456"]
  end

  test "parse_range" do
    assert DayTwo.parse_range("1-3") === 1..3
    assert DayTwo.parse_range("3-5") === 3..5
    assert DayTwo.parse_range("9-15") === 9..15
  end

  test "get_invalid_ids_part_one" do
    test_input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert Enum.take(DayTwo.get_invalid_ids(test_input, &DayTwo.is_invalid_id_part_one/1), 8) ===
             [
               11,
               22,
               99,
               1010,
               1_188_511_885,
               222_222,
               446_446,
               38_593_859
             ]
  end

  test "sum_invalid_ids_part_one" do
    test_input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert DayTwo.sum_invalid_ids(test_input, &DayTwo.is_invalid_id_part_one/1) === 1_227_775_554
  end

  test "solve part one" do
    assert DayTwo.solve_part_one() === 53_420_042_388
  end

  test "finds invalid id part two" do
    assert DayTwo.is_invalid_id_part_two("55")
    assert DayTwo.is_invalid_id_part_two("6464")
    assert DayTwo.is_invalid_id_part_two("123123")

    assert not DayTwo.is_invalid_id_part_two("5")
    assert not DayTwo.is_invalid_id_part_two("64")
    assert not DayTwo.is_invalid_id_part_two("123")
    assert not DayTwo.is_invalid_id_part_two("101")

    assert DayTwo.is_invalid_id_part_two(55)
    assert DayTwo.is_invalid_id_part_two(6464)
    assert DayTwo.is_invalid_id_part_two(123_123)

    assert not DayTwo.is_invalid_id_part_two(5)
    assert not DayTwo.is_invalid_id_part_two(64)
    assert not DayTwo.is_invalid_id_part_two(123)
    assert not DayTwo.is_invalid_id_part_two(101)
  end

  test "get_invalid_ids_part_two" do
    test_input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert Enum.take(DayTwo.get_invalid_ids(test_input, &DayTwo.is_invalid_id_part_two/1), 100) ===
             [
               11,
               22,
               99,
               111,
               999,
               1010,
               1_188_511_885,
               222_222,
               446_446,
               38_593_859,
               565_656,
               824_824_824,
               2_121_212_121
             ]
  end

  test "sum_invalid_ids_part_two" do
    test_input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert DayTwo.sum_invalid_ids(test_input, &DayTwo.is_invalid_id_part_two/1) === 4_174_379_265
  end

  test "solve part two" do
    assert DayTwo.solve_part_two() === 69_553_832_684
  end
end
