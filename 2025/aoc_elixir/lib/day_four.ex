defmodule DayFour do
  @moduledoc """
  Day Four of AOC
  """

  def parse_row(line, row_num) do
    line
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.filter(fn {val, _index} -> val === ?@ end)
    |> Enum.map(fn {_val, index} -> index end)
    |> Enum.map(fn col -> {row_num, col} end)
    |> Map.from_keys(1)
  end

  def parse_grid(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(fn {val, index} -> parse_row(val, index) end)
    |> Enum.reduce(fn elem, acc -> Map.merge(elem, acc) end)
  end

  def neighbour_positions({x, y}) do
    neighbour_offsets = [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]
    Enum.map(neighbour_offsets, fn {offset_x, offset_y} -> {x + offset_x, y + offset_y} end)
  end

  def filled_neighbours(map, pos) do
    pos
    |> neighbour_positions()
    |> Enum.filter(&Map.has_key?(map, &1))
  end

  def num_filled_neighbours(map, pos) do
    filled_neighbours(map, pos)
    |> Enum.count()
  end

  def spots_with_filled_neighbours(map, max_neighbours) do
    map
    |> Map.keys()
    |> Enum.filter(&(num_filled_neighbours(map, &1) <= max_neighbours))
  end

  def num_spots_with_filled_neighbours(map, max_neighbours) do
    spots_with_filled_neighbours(map, max_neighbours)
    |> Enum.count()
  end

  def solve_p1 do
    AocElixir.read_input(4)
    |> String.split("\n")
    |> parse_grid()
    |> num_spots_with_filled_neighbours(3)
  end

  def remove_spots_with_filled_neighbours(map, max_neighbours) do
    removable = spots_with_filled_neighbours(map, max_neighbours)

    case removable do
      [] ->
        0

      _list ->
        Enum.count(removable) +
          remove_spots_with_filled_neighbours(Map.drop(map, removable), max_neighbours)
    end
  end

  def solve_p2 do
    AocElixir.read_input(4)
    |> String.split("\n")
    |> parse_grid()
    |> remove_spots_with_filled_neighbours(3)
  end

  def main do
    IO.puts(~s"Part One: #{solve_p1()}")
    IO.puts(~s"Part Two: #{solve_p2()}")
  end

  def bench do
    Benchee.run(%{
      "part one" => &solve_p1/0,
      "part two" => &solve_p2/0
    })
  end
end
