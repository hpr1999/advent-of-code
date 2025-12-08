defmodule DayEight do
  @moduledoc """
  Day Eight of AOC
  """

  import Benchee

  ### PARSING ###

  def parse() do
    parse(AocElixir.read_lines(8))
  end

  def parse(lines) do
  end

  ### PART ONE ###
  def part1(input_lines) do
  end

  ### PART 2 ###
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
      "parse" => fn -> parse() end,
      "part one" => fn -> part1(input) end,
      "part two" => fn -> part2(input) end
    })
  end
end
