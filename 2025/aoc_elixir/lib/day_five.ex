defmodule DayFive do
  @moduledoc """
  Day Five of AOC
  """
  import Benchee

  ### PARSING ###

  def parse, do: parse(String.trim(AocElixir.read_input(5)))

  def parse(input) do
    [fresh_lines, test_lines] =
      input
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))

    fresh_ranges = fresh_lines |> parse_fresh() |> compact_ranges()
    test_ids = test_lines |> Enum.map(&String.to_integer/1)

    {fresh_ranges, test_ids}
  end

  defp contains?({from, to}, num), do: from <= num and num <= to

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
  end

  ### PART 1 ###

  def fresh?(fresh_ranges, num), do: Enum.any?(fresh_ranges, &contains?(&1, num))

  def part1({fresh_ranges, test_nums}), do: Enum.count(test_nums, &fresh?(fresh_ranges, &1))

  ### PART 2 ###

  defp num_ids({from, to}), do: to - from + 1

  def part2({fresh_ranges, _test_nums}), do: fresh_ranges |> Enum.sum_by(&num_ids(&1))

  ### BORING PLUMBING ###

  def solve_part1, do: parse() |> part1()
  def solve_part2, do: parse() |> part2()

  def main do
    input = parse()

    IO.puts(~s"Part One: #{part1(input)}")
    IO.puts(~s"Part Two: #{part2(input)}")
  end

  def bench do
    input = parse()

    run(%{
      "parse" => fn -> parse(AocElixir.read_input(5)) end,
      "part one" => fn -> part1(input) end,
      "part two" => fn -> part2(input) end
    })
  end
end
