defmodule DayTen do
  @moduledoc """
  Day Ten of AOC
  """
  alias DayTen.Machine
  import Benchee
  require Integer

  ### PARSING ###

  def parse() do
    parse(AocElixir.read_lines(10))
  end

  defmodule Machine do
    defstruct [:indicator_target, :buttons, :joltage_requirement]

    defp on(), do: ?#
    defp on?(char) when is_integer(char), do: char === on()

    def parse_indicators(segment) do
      segment
      |> String.slice(1..(String.length(segment) - 2))
      |> String.to_charlist()
      |> Enum.map(&on?/1)
    end

    def parse_button(button_segment) do
      button_segment
      |> String.slice(1..(String.length(button_segment) - 2))
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end

    def parse_joltage(joltage_segment) do
      joltage_segment
      |> String.slice(1..(String.length(joltage_segment) - 2))
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end

    def parse_machine(line) do
      segments = line |> String.split()

      %Machine{
        indicator_target: hd(segments) |> parse_indicators(),
        buttons: tl(segments) |> Enum.drop(-1) |> Enum.map(&parse_button/1),
        joltage_requirement: List.last(segments) |> parse_joltage()
      }
    end
  end

  @doc """
      
  iex> DayTen.parse(["[.##.] (3) (1,3,5,7,8,9,0) (2) (2,3) (0,2) (0,1) {3,50,411,7}"])
  [
    %DayTen.Machine{
      indicator_target: [false, true, true, false],
      buttons: [[3], [1, 3,5,7,8,9,0], [2], [2, 3], [0, 2], [0, 1]],
      joltage_requirement: [3, 50, 411, 7]
    }
  ]
  """
  def parse(lines) do
    lines |> Enum.map(&Machine.parse_machine/1)
  end

  ### PART ONE ###

  def toggle(bool) when is_boolean(bool), do: not bool

  def toggle(indicators, button_toggles) when is_list(indicators) and is_list(button_toggles) do
    for {state, index} <- Enum.with_index(indicators) do
      if index in button_toggles, do: toggle(state), else: state
    end
  end

  def combinations(_list, 0) do
    [[]]
  end

  def combinations(list, num) do
    for head <- list,
        rest_combinations = combinations(list, num - 1),
        filtered_rest_combinations =
          Enum.uniq_by(rest_combinations, fn combination -> Enum.sort(combination) end),
        y <- filtered_rest_combinations do
      [head | y]
    end
  end

  def button_combination_stream(%Machine{} = m) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.flat_map(fn length ->
      m.buttons |> combinations(length)
    end)
  end

  def solves_machine?(indicator_target, buttons) do
    initial_state = Enum.map(indicator_target, fn _ -> false end)

    indicator_result =
      Enum.reduce(
        buttons,
        initial_state,
        fn button, state -> toggle(state, button) end
      )

    indicator_result === indicator_target
  end

  def part1(machines) when is_list(machines) do
    button_solutions =
      for %Machine{} = m <- machines do
        button_combination_stream(m)
        |> Enum.find(&solves_machine?(m.indicator_target, &1))
      end

    button_solutions |> Enum.map(&Enum.count/1) |> Enum.sum()

    # get permutations of size n
    # try them all
    # check if any permutation will cause the machine to be fixed
    # if yes, return, if not increase n
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
