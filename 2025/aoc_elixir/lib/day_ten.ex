defmodule DayTen do
  @moduledoc """
  Day Ten of AOC
  """
  import Benchee
  require Integer

  ### PARSING ###

  def parse() do
    parse(AocElixir.read_lines(9))
  end

  def line_to_point(line) do
    [x, y] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
    {x, y}
  end

  def parse(lines) do
    lines |> Enum.map(&line_to_point/1)
  end

  ### PART ONE ###
  def part1(input) do
  end

  ### PART TWO ###
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
