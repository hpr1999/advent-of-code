defmodule DayTwoTest do
  use ExUnit.Case
  doctest DayTwo

  test "finds invalid id" do
    assert DayTwo.is_invalid_id("55")
    assert DayTwo.is_invalid_id("6464")
    assert DayTwo.is_invalid_id("123123")

    assert not DayTwo.is_invalid_id("5")
    assert not DayTwo.is_invalid_id("64")
    assert not DayTwo.is_invalid_id("123")
    assert not DayTwo.is_invalid_id("101")

    assert DayTwo.is_invalid_id(55)
    assert DayTwo.is_invalid_id(6464)
    assert DayTwo.is_invalid_id(123_123)

    assert not DayTwo.is_invalid_id(5)
    assert not DayTwo.is_invalid_id(64)
    assert not DayTwo.is_invalid_id(123)
    assert not DayTwo.is_invalid_id(101)
  end

  test "split_in_middle" do
    assert DayTwo.split_in_middle("55") === {"5", "5"}
    assert DayTwo.split_in_middle("64") === {"6", "4"}
    assert DayTwo.split_in_middle("6464") === {"64", "64"}
  end

  test "parse_range" do
    assert DayTwo.parse_range("1-3") === 1..3
    assert DayTwo.parse_range("3-5") === 3..5
    assert DayTwo.parse_range("9-15") === 9..15
  end

  test "get_invalid_ids" do
    test_input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert Enum.take(DayTwo.get_invalid_ids(test_input), 8) === [
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

  test "sum_invalid_ids" do
    test_input =
      "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

    assert DayTwo.sum_invalid_ids(test_input) === 1_227_775_554
  end
end
