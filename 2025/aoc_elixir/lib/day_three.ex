defmodule DayThree do
  @moduledoc """
  Day Three of AOC
  """
  def joltage(battery_bank, num_batteries) when is_integer(battery_bank) do
    joltage(Integer.digits(battery_bank), num_batteries, 0)
  end

  defp joltage(battery_bank, num_batteries, sum)
       when is_list(battery_bank) and num_batteries >= 0 and sum >= 0 do
    # when we only need one more battery, just get the biggest that's left
    if num_batteries == 1 do
      sum + Enum.max(battery_bank)
    else
      [num | rest] = largest_digit_sequence(battery_bank, num_batteries)
      battery_value = num * Integer.pow(10, num_batteries - 1)
      joltage(rest, num_batteries - 1, sum + battery_value)
    end
  end

  def largest_digit_sequence(digits, min_trail_size) when is_list(digits) do
    largest_digit_sequence(min_trail_size, digits, digits)
  end

  defp largest_digit_sequence(sequence_length, digits_to_check, result) do
    case digits_to_check do
      # If we need all remaining digits to satisfy the length, we return
      list when is_list(list) and length(list) < sequence_length ->
        result

      [head | tail] ->
        result = if head > hd(result), do: digits_to_check, else: result
        largest_digit_sequence(sequence_length, tail, result)
    end
  end

  def solve_p1(battery_banks) when is_list(battery_banks) do
    battery_banks
    |> Enum.map(fn battery_bank -> joltage(battery_bank, 2) end)
    |> Enum.sum()
  end

  def solve_p2(battery_banks) when is_list(battery_banks) do
    battery_banks
    |> Enum.map(fn battery_bank -> joltage(battery_bank, 12) end)
    |> Enum.sum()
  end

  def solve_p1() do
    AocElixir.read_lines(3)
    |> Enum.map(&String.to_integer/1)
    |> solve_p1()
  end

  def solve_p2() do
    AocElixir.read_lines(3)
    |> Task.async_stream(fn str ->
      joltage(String.to_integer(str), 12)
    end)
    |> Enum.sum_by(fn {:ok, data} -> data end)
  end

  def main do
    IO.puts(~s"Part One: #{solve_p1()}")
    IO.puts(~s"Part Two: #{solve_p2()}")
  end
end
