defmodule DayEight do
  @moduledoc """
  Day Eight of AOC
  """

  import Benchee

  ### PARSING ###

  def parse() do
    parse(AocElixir.read_lines(8))
  end

  def line_to_point(line) do
    [x, y, z] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
    {x, y, z}
  end

  def parse(lines) do
    lines |> Enum.map(&line_to_point/1)
  end

  ### PART ONE ###
  def part1(junctions, num_connections \\ 1000) do
    shortest_distances = shortest_distances(junctions)

    connections = Enum.take(shortest_distances, num_connections)

    circuits = make_circuits(connections)

    circuits
    |> Enum.map(&Enum.count/1)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.product()
  end

  def connect_to_circuits(connection, circuits) do
    {left, right} = connection

    existing_circuits_left = Enum.filter(circuits, &Enum.member?(&1, left))
    existing_circuits_right = Enum.filter(circuits, &Enum.member?(&1, right))

    connect_circuits = fn circuits ->
      Enum.flat_map(circuits, fn circuit -> circuit end) |> Enum.uniq()
    end

    case {existing_circuits_left, existing_circuits_right} do
      {[], []} ->
        [[left, right] | circuits]

      {_, []} ->
        new_circuit = [right | connect_circuits.(existing_circuits_left)]
        without_old_circuits = circuits -- existing_circuits_left

        [new_circuit | without_old_circuits]

      {[], _} ->
        new_circuit = [left | connect_circuits.(existing_circuits_right)]
        without_old_circuits = circuits -- existing_circuits_right

        [new_circuit | without_old_circuits]

      {_, _} ->
        lefts = connect_circuits.(existing_circuits_left)
        rights = connect_circuits.(existing_circuits_right)
        new_circuit = (lefts ++ rights) |> Enum.uniq()

        without_old_circuits = circuits -- existing_circuits_left
        without_old_circuits = without_old_circuits -- existing_circuits_right

        [new_circuit | without_old_circuits]
    end
  end

  def make_circuits(connections) do
    Enum.reduce(connections, [], &connect_to_circuits/2)
  end

  def distance({point_a, point_b}), do: distance(point_a, point_b)

  def distance({x1, y1, z1}, {x2, y2, z2}) do
    ((x1 - x2) ** 2 + (y1 - y2) ** 2 + (z1 - z2) ** 2) ** 0.5
  end

  def pairs(anys, results \\ [])
  def pairs([], results), do: results

  def pairs([head | tail], results) do
    ps = for el <- tail, do: {head, el}
    pairs(tail, ps ++ results)
  end

  def shortest_distances(points) do
    points |> pairs() |> Enum.sort_by(&distance/1)
  end

  ### PART 2 ###
  def part2(junctions) do
    shortest_distances = shortest_distances(junctions)
    num_junctions = Enum.count(junctions)

    last_connection =
      Enum.reduce_while(shortest_distances, [], fn connection, circuits ->
        new_circuits = connect_to_circuits(connection, circuits)

        if Enum.empty?(tl(new_circuits)) and Enum.count(hd(new_circuits)) === num_junctions do
          {:halt, connection}
        else
          {:cont, new_circuits}
        end
      end)

    {{x1, _y1, _z1}, {x2, _y2, _z2}} = last_connection
    x1 * x2
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
