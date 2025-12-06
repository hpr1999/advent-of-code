defmodule DayFive do
  @moduledoc """
  Day Five of AOC
  """

  defp map_ranges(range, :default), do: {[], range}

  defp map_ranges({new_from, new_to}, {current_from, current_to}) do
    if contains?({current_from, current_to}, new_from) do
      # don't add the element just yet, instead merge it into accumulator, we're gathering a bigger range
      {[], {current_from, max(new_to, current_to)}}
    else
      # stop gathering the current range and add it into the list, start gathering the new range as the accumulator to check merges for next elements
      {[{current_from, current_to}], {new_from, new_to}}
    end
  end

  defp merge_last_accumulator({results, last_acc}), do: results ++ [last_acc]

  def compact_ranges(ranges) do
    ranges
    |> Enum.group_by(fn {from, _to} -> from end, fn {_from, to} -> to end)
    |> Enum.map(fn {key, values} -> {key, Enum.max(values)} end)
    |> Enum.sort_by(fn {from, _to} -> from end)
    |> Enum.flat_map_reduce(:default, &map_ranges/2)
    |> merge_last_accumulator()
  end

  def parse_fresh(range_lines) do
    range_lines
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.map(fn [from, to] -> {String.to_integer(from), String.to_integer(to)} end)
    |> Enum.sort_by(fn {from, _to} -> from end)
  end

  def contains?({from, to}, num) do
    from <= num and num <= to
  end

  def fresh?(fresh_ranges, num) do
    range =
      fresh_ranges
      |> Enum.find(&contains?(&1, num))

    if range == nil, do: false, else: true
  end

  def num_ids({from, to}), do: to - from + 1

  def to_str({from, to}), do: ~s"from: #{from}, to: #{to}"
  def to_str(nil), do: "not"

  def num_fresh(fresh_ranges, test_nums) do
    Enum.count(test_nums, &fresh?(fresh_ranges, &1))
  end

  def solve_p1(input) do
    [fresh_lines, test_lines] =
      input
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))

    fresh_ranges = fresh_lines |> parse_fresh() |> compact_ranges()

    test_nums = test_lines |> Enum.map(&String.to_integer/1)
    num_fresh(fresh_ranges, test_nums)
  end

  def solve_p2(input) do
    [fresh_lines, _test_lines] =
      input
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))

    fresh_ranges = fresh_lines |> parse_fresh() |> compact_ranges()

    fresh_ranges |> Enum.map(&num_ids(&1)) |> Enum.sum()
  end

  def main do
    input = AocElixir.read_input(5)
    IO.puts(~s"Part One: #{solve_p1(input)}")
    IO.puts(~s"Part Two: #{solve_p2(input)}")
  end

  def bench do
    input = AocElixir.read_input(5)

    Benchee.run(%{
      "part one" => fn -> solve_p1(input) end,
      "part two" => fn -> solve_p2(input) end
    })
  end
end
