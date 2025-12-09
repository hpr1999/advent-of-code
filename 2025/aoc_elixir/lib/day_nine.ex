defmodule DayNine do
  @moduledoc """
  Day Nine of AOC
  """

  import Benchee

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

  def sublists(list, results \\ [])

  def sublists([head], results) do
    [[head] | results]
  end

  def sublists([head | tail], results) do
    sublists(tail, [[head | tail] | results])
  end

  def pairs(list, condition) do
    for sublist <- sublists(list), [a | tail] = sublist, b <- tail, condition.(a, b) do
      {a, b}
    end
  end

  def area({{x1, y1}, {x2, y2}}) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  def part1(points) do
    points
    |> pairs(fn {x1, y1}, {x2, y2} -> x1 !== x2 and y1 !== y2 end)
    |> Enum.map(&area/1)
    |> Enum.max()
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
