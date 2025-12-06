defmodule DaySix do
  @moduledoc """
  Day Six of AOC
  """
  import Benchee

  def parse() do
  end

  def parse(input) do
  end

  def part1(input) do
  end

  def part2(input) do
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
      "parse" => fn -> parse(AocElixir.read_input(6)) end,
      "part one" => fn -> part1(input) end,
      "part two" => fn -> part2(input) end
    })
  end
end
