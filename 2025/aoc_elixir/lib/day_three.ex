defmodule DayThree do
  def calc_joltage(bat_bank, num_batteries) when is_integer(bat_bank) do
    calc_joltage(Integer.digits(bat_bank), num_batteries, 0)
  end

  defp calc_joltage(bat_bank, num_batteries, sum)
       when is_list(bat_bank) and num_batteries >= 0 and sum >= 0 do
    if num_batteries == 1 do
      sum + Enum.max(bat_bank)
    else
      [num | rest] = find_max_digit_with_trail(bat_bank, num_batteries)
      calc_joltage(rest, num_batteries - 1, sum + num * Integer.pow(10, num_batteries - 1))
    end
  end

  def find_max_digit_with_trail(digits, min_trail_size) when is_list(digits) do
    find_max_digit_with_trail(digits, digits, min_trail_size)
  end

  defp find_max_digit_with_trail(remaining_digits, result_digits, min_trail_size) do
    [max | _trail] = result_digits

    case remaining_digits do
      list when is_list(list) and length(list) < min_trail_size ->
        result_digits

      [head | tail] when head > max ->
        find_max_digit_with_trail(tail, remaining_digits, min_trail_size)

      [head | tail] when head <= max ->
        find_max_digit_with_trail(tail, result_digits, min_trail_size)
    end
  end

  def solve_part_one(bat_banks) when is_list(bat_banks) do
    bat_banks
    |> Enum.map(fn bat_bank -> calc_joltage(bat_bank, 2) end)
    |> Enum.sum()
  end

  def solve_part_two(bat_banks) when is_list(bat_banks) do
    bat_banks
    |> Enum.map(fn bat_bank -> calc_joltage(bat_bank, 12) end)
    |> Enum.sum()
  end

  def solve_part_one() do
    AocElixir.read_input(3)
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> solve_part_one()
  end

  def solve_part_two() do
    AocElixir.read_input(3)
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> solve_part_two()
  end

  def main do
    IO.puts(~s"Part One: #{solve_part_one()}")
    IO.puts(~s"Part Two: #{solve_part_two()}")
  end
end
