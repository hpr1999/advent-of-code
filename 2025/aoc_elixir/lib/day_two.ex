defmodule DayTwo do
  @moduledoc """
  Day Two of AOC
  """
  require Integer

  def is_invalid_id(id) when is_number(id) do
    is_invalid_id(Integer.to_string(id))
  end

  def is_invalid_id(id) when is_binary(id) do
    length = String.length(id)

    if rem(length, 2) == 0 do
      {left, right} = split_in_middle(id)
      left === right
    else
      false
    end
  end

  def split_in_middle(str) do
    length = String.length(str)
    middle_index = div(String.length(str), 2) - 1
    {String.slice(str, 0..middle_index), String.slice(str, (middle_index + 1)..length)}
  end

  def parse_range(id_range) do
    [left, right] = String.split(id_range, "-")
    String.to_integer(left)..String.to_integer(right)
  end

  def get_invalid_ids(ids) do
    ids
    |> String.splitter([","], [:trim])
    |> Enum.map(&parse_range/1)
    |> Enum.flat_map(& &1)
    |> Enum.filter(&is_invalid_id/1)
  end

  def sum_invalid_ids(ids) do
    ids
    |> get_invalid_ids()
    |> Enum.reduce(&(&1 + &2))
  end

  def solve_part_one do
    sum_invalid_ids(AocElixir.read_input(2))
  end

  def main do
    IO.puts(~s"Part One: #{solve_part_one()}")
  end
end
