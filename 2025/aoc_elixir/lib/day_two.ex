defmodule DayTwo do
  @moduledoc """
  Day Two of AOC
  """
  require Integer

  def invalid_id_p1?(id) when is_number(id) do
    invalid_id_p1?(Integer.to_string(id))
  end

  def invalid_id_p1?(id) when is_binary(id) do
    length = String.length(id)

    if rem(length, 2) == 0 do
      has_repetition_of_length?(id, 2)
    else
      false
    end
  end

  def split_in_middle(str) do
    middle_index = div(String.length(str), 2)
    String.split_at(str, middle_index)
  end

  def invalid_id_p2?(id) when is_number(id) do
    invalid_id_p2?(Integer.to_string(id))
  end

  def invalid_id_p2?(id) when is_binary(id) do
    length = String.length(id)

    1..length
    |> Enum.map(fn len -> has_repetition_of_length?(id, len) end)
    |> Enum.any?()
  end

  def has_repetition_of_length?(id, len) do
    length = String.length(id)

    if rem(length, len) == 0 do
      [first_part | parts] = split_multiple(id, div(length, len))
      Enum.any?(parts) and Enum.all?(parts, &(first_part === &1))
    else
      false
    end
  end

  def split_multiple(str, len) do
    {left, right} = String.split_at(str, len)

    if String.length(right) < len do
      [left]
    else
      [left | split_multiple(right, len)]
    end
  end

  def parse_range(id_range) do
    [left, right] = String.split(id_range, "-")
    String.to_integer(left)..String.to_integer(right)
  end

  def get_invalid_ids(ids, is_invalid_id) do
    ids
    |> String.splitter([","], [:trim])
    |> Task.async_stream(fn range ->
      Enum.filter(parse_range(range), is_invalid_id)
    end)
    |> Enum.flat_map(fn result ->
      {_status, datalist} = result
      datalist
    end)
  end

  def sum_invalid_ids(ids, is_invalid_id) do
    ids
    |> get_invalid_ids(is_invalid_id)
    |> Enum.reduce(&(&1 + &2))
  end

  def solve_p1 do
    sum_invalid_ids(AocElixir.read_input(2), &invalid_id_p1?/1)
  end

  def solve_p2 do
    sum_invalid_ids(AocElixir.read_input(2), &invalid_id_p2?/1)
  end

  def main do
    IO.puts(~s"Part One: #{solve_p1()}")
    IO.puts(~s"Part Two: #{solve_p2()}")
  end
end
