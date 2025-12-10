defmodule DayNine do
  @moduledoc """
  Day Nine of AOC
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

  def direction(line) do
    {{xp1, yp1}, {xp2, yp2}} = line
    vertical = xp1 === xp2
    horizontal = yp1 === yp2

    cond do
      horizontal and vertical -> :point
      horizontal -> :horizontal
      vertical -> :vertical
    end
  end

  def hline?(line) do
    direction(line) === :horizontal
  end

  def vline?(line) do
    direction(line) === :vertical
  end

  def intersect_orthogonal(aline, bline) do
    cond do
      hline?(aline) and vline?(bline) ->
        intersect_hline_vline(aline, bline)

      hline?(bline) and vline?(aline) ->
        intersect_hline_vline(bline, aline)

      true ->
        nil
    end
  end

  def small_big({a, b}), do: small_big(a, b)

  def small_big(a, b) do
    if a < b, do: {a, b}, else: {b, a}
  end

  def intersect_hline_vline(hline, vline) do
    {{hx1, hy1}, {hx2, _hy2}} = hline
    {{vx1, vy1}, {_vx2, vy2}} = vline

    {hleft, hright} = small_big(hx1, hx2)
    {vup, vdown} = small_big(vy1, vy2)

    intersect? = hleft <= vx1 and hright >= vx1 and vup <= hy1 and vdown >= hy1

    if intersect?, do: {vx1, hy1}, else: nil
  end

  def horizontal_edge_line(point) do
    {_x, y} = point
    {point, {-1, y}}
  end

  def point_on_line?(line, point) do
    {{xp1, yp1}, {xp2, yp2}} = line
    {xp, yp} = point

    {left, right} = small_big(xp1, xp2)
    {up, down} = small_big(yp1, yp2)

    (xp === left and xp === right and up <= yp and yp <= down) or
      (yp === up and yp === down and left <= xp and xp <= right)
  end

  def point_in_polygon?(polygon, point) do
    if Enum.any?(polygon, fn line -> point_on_line?(line, point) end) do
      true
    else
      hline = horizontal_edge_line(point)

      intersections =
        Enum.filter(polygon, &vline?/1)
        |> Enum.map(fn vline -> intersect_hline_vline(hline, vline) end)
        # filter nils when counting
        |> Enum.count(& &1)

      Integer.is_odd(intersections)
    end
  end

  def sign(num) when num < 0, do: -1
  def sign(num) when num > 0, do: 1
  def sign(0), do: 0

  def point_in_rect?(rect, point) do
    {{x1, y1}, {x2, y2}} = rect
    {xp, yp} = point

    {left, right} = small_big(x1, x2)
    {up, down} = small_big(y1, y2)

    left <= xp and xp <= right and
      up <= yp and yp <= down
  end

  def rect_lines(rect) do
    {{x1, y1}, {x2, y2}} = rect
    {left, right} = small_big(x1, x2)
    {up, down} = small_big(y1, y2)

    [
      {{left, up}, {right, up}},
      {{right, up}, {right, down}},
      {{right, down}, {left, down}},
      {{left, down}, {left, up}}
    ]
  end

  def rect_in_polygon?(polygon, rect) do
    {{x1, y1}, {x2, y2}} = rect
    xadd = sign(x1 - x2)
    yadd = sign(y1 - y2)

    {left, right} = small_big(x1, x2)
    {up, down} = small_big(y1, y2)

    inner_rect = {{left + 1, up + 1}, {right - 1, down - 1}}

    point_inside = {x1 - xadd, y1 - yadd}
    point_inside_polygon? = point_in_polygon?(polygon, point_inside)

    rect_lines = rect_lines(rect)

    polygon_without_rect_lines =
      Enum.reject(polygon, fn line ->
        Enum.any?(rect_lines, fn rect_line ->
          {p1, p2} = rect_line
          line === {p1, p2} or line === {p2, p1}
        end)
      end)

    ### FIXME
    # check for all polygon lines if they intersect the orthogonal rect_lines in a bad way (e.g. don't just "touch")
    # 
    # touch = intersect + anchor on line -> ok
    # polygon line cuts into rect -> bad
    # polygon line cuts through rect -> bad
    # polygon line is on the side of the rect, e.g. it IS one of the rect_lines -> ok
    # ## -> filter the polygon_lines (reject all with the same x/y as the relevant rect_lines)
    #
    # bad if polygon line intersects 2 rect lines
    # bad if polygon_line intersects 1 rect line and one anchor is inside the rect

    any_intersection? =
      Enum.any?(polygon_without_rect_lines, fn polygon_line ->
        num_intersections =
          Enum.count(rect_lines, fn rect_line ->
            intersect_orthogonal(polygon_line, rect_line)
          end)

        {anchor_a, anchor_b} = polygon_line

        cond do
          num_intersections >= 2 ->
            true

          num_intersections === 1 and
              (point_in_rect?(inner_rect, anchor_a) or point_in_rect?(inner_rect, anchor_b)) ->
            true

          true ->
            false
        end
      end)

    point_inside_polygon? and not any_intersection?
  end

  def sliding_window_chunks(list, num_window_size)
      when is_list(list) and num_window_size > length(list) do
    []
  end

  def sliding_window_chunks(list, num_window_size)
      when is_list(list) and num_window_size <= length(list) do
    {initial, rest} = Enum.split(list, num_window_size)

    Enum.chunk_while(
      rest,
      initial,
      fn elem, acc ->
        new_acc = tl(acc) ++ [elem]
        emitted_chunk = acc
        {:cont, emitted_chunk, new_acc}
      end,
      # emit the remaining accumulator
      fn acc -> {:cont, acc, []} end
    )
  end

  def part2(input) do
    rect_candidates = input |> pairs(fn {x1, y1}, {x2, y2} -> x1 !== x2 and y1 !== y2 end)
    polygon = input |> sliding_window_chunks(2) |> Enum.map(fn [a, b] -> {a, b} end)
    loop_line = {List.last(input), hd(input)}
    polygon = [loop_line | polygon]

    rect_candidates
    |> Enum.filter(&rect_in_polygon?(polygon, &1))
    |> Enum.map(&area/1)
    |> Enum.max()
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
