defmodule DayThree do
  def calc_joltage(bat_bank) when is_integer(bat_bank) do
    [first_num | rest] = find_max_digit_with_trail(bat_bank)
    second_num = Enum.max(rest)

    first_num * 10 + second_num
  end

  def find_max_digit_with_trail(int) when is_integer(int) do
    digits = Integer.digits(int)
    find_max_digit_with_trail(digits, digits)
  end

  defp find_max_digit_with_trail(remaining_digits, result_digits) do
    [max | _trail] = result_digits

    case remaining_digits do
      [_last] -> result_digits
      [head | tail] when head > max -> find_max_digit_with_trail(tail, remaining_digits)
      [head | tail] when head <= max -> find_max_digit_with_trail(tail, result_digits)
    end
  end

  def sum_joltages(bat_banks) when is_list(bat_banks) do
    bat_banks
    # |> Task.async_stream(&calc_joltage/1)
    # |> Enum.sum_by(fn {:ok, joltage} -> joltage end)
    |> Enum.map(&calc_joltage/1)
    |> Enum.sum()
  end

  def solve_part_one() do
    AocElixir.read_input(3)
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> sum_joltages()
  end

  def solve_part_two() do
  end

  def main do
    IO.puts(~s"Part One: #{solve_part_one()}")
    IO.puts(~s"Part Two: #{solve_part_two()}")
  end
end
