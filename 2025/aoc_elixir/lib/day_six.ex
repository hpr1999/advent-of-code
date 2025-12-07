defmodule DaySix do
  @moduledoc """
  Day Six of AOC
  """
  import Benchee

  ### PARSING ###

  def parse() do
    parse(AocElixir.read_lines(6))
  end

  def parse_op(op) when op === "+", do: &Kernel.+/2
  def parse_op(op) when op === "*", do: &Kernel.*/2

  def parse_ops(raw_ops_row), do: raw_ops_row |> String.split() |> Enum.map(&parse_op/1)

  def parse(lines) do
    row_num = Enum.count(lines)
    {raw_num_rows, [raw_ops_row]} = Enum.split(lines, row_num - 1)
    {raw_num_rows, parse_ops(raw_ops_row)}
  end

  ### PART 1 ###

  def parse_str_num(str_num), do: str_num |> String.trim() |> String.to_integer()

  def combine(row1, row2, fns) do
    Enum.zip_with([row1, row2, fns], fn [a, b, op] -> op.(a, b) end)
  end

  def part1({raw_num_rows, ops}) do
    num_rows =
      Enum.map(
        raw_num_rows,
        fn row -> String.split(row) |> Enum.map(&parse_str_num/1) end
      )

    num_rows
    # associate each column with its operation
    |> Enum.reduce(&combine(&1, &2, ops))
    |> Enum.sum()
  end

  ### PART 2 ###

  def split_on_condition(enum, condition) do
    enum
    |> Enum.chunk_while(
      [],
      fn char, acc ->
        if condition.(char) do
          # emit a chunk with all previous values once condition is hit
          # reverse because cons would otherwise reverse the input
          {:cont, Enum.reverse(acc), []}
        else
          # accumulate non-matching values
          {:cont, [char | acc]}
        end
      end,
      # emit the remaining accumulator
      fn acc -> {:cont, Enum.reverse(acc), []} end
    )
  end

  def part2({raw_num_rows, ops}) do
    column_charlists =
      raw_num_rows
      |> Enum.map(&String.to_charlist/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list(&1))

    grouped_num_columns =
      column_charlists
      |> split_on_condition(&Enum.all?(&1, fn char -> char === ?\s end))
      |> Enum.map(
        &Enum.map(&1, fn col ->
          col
          |> to_string()
          |> String.trim()
          |> String.to_integer()
        end)
      )

    Enum.zip(ops, grouped_num_columns)
    |> Enum.map(fn {op, cols} -> Enum.reduce(cols, op) end)
    |> Enum.sum()
  end

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
      "parse" => fn -> parse() end,
      "part one" => fn -> part1(input) end,
      "part two" => fn -> part2(input) end
    })
  end
end
