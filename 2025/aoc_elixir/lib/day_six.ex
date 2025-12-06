defmodule DaySix do
  @moduledoc """
  Day Six of AOC
  """
  import Benchee

  def parse() do
    parse(AocElixir.read_input(6))
  end

  def parse(input) do
    {lines, [ops]} =
      input |> String.split("\n") |> Enum.map(&String.split/1) |> Enum.split(-1)

    lines = lines |> Enum.map(fn line -> line |> Enum.map(&String.to_integer/1) end)
    ops = ops |> Enum.map(&parse_op/1)

    {lines, ops}
  end

  def part1({num_rows, ops}) do
    num_columns = num_rows |> Enum.zip()

    [num_columns, ops]
    # associate each column with its operation
    |> Enum.zip()
    # apply operation
    |> Enum.map(fn {num_tpl, op} -> op.(num_tpl) end)
    |> Enum.sum()
  end

  def part2({num_rows, ops}) do
  end

  def combine(row1, row2, fns) do
    Enum.zip_with([row1, row2, fns], fn [a, b, op] -> op.(a, b) end)
  end

  def parse_op(op) when op === "+", do: &Tuple.sum/1
  def parse_op(op) when op === "*", do: &Tuple.product/1

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
      "parse" => fn -> parse(AocElixir.read_input(6)) end,
      "part one" => fn -> part1(input) end,
      "part two" => fn -> part2(input) end
    })
  end
end
