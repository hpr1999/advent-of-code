defmodule DaySeven do
  @moduledoc """
  Day Seven of AOC
  """
  import Benchee

  ### PARSING ###

  def parse() do
    parse(AocElixir.read_lines(7))
  end

  def parse(lines) do
    Enum.map(lines, &String.to_charlist/1)
  end

  ### PART ONE ###

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

  defp process_chunks(chunks, join_fun) do
    {heads, tails} = chunks |> Enum.map(&Enum.split(&1, 1)) |> Enum.unzip()
    heads = heads |> Enum.reject(&Enum.empty?/1)
    tails = tails |> Enum.reject(&Enum.empty?/1)

    head = heads |> Enum.map(&hd/1) |> join_fun.()

    {head, tails}
  end

  defp join_chunks(remaining_chunks, current_chunks, join_fun, results) do
    case {remaining_chunks, current_chunks} do
      {[], []} ->
        results

      {[], current_chunks} ->
        {head, tails} = process_chunks(current_chunks, join_fun)
        join_chunks([], tails, join_fun, [head | results])

      {[new_chunk | next_remaining_chunks], current_chunks} ->
        current_chunks = [new_chunk | current_chunks]
        {head, tails} = process_chunks(current_chunks, join_fun)
        join_chunks(next_remaining_chunks, tails, join_fun, [head | results])
    end
  end

  def join_chunks(chunks, join_fun), do: join_chunks(chunks, [], join_fun, [])

  def part1(input) do
    input
    |> Enum.reduce([], fn line, result ->
      if Enum.empty?(result) do
        [line | result]
      else
        prev_line = hd(result)

        new_line =
          Enum.zip(prev_line, line)
          |> Enum.map(fn vals ->
            case vals do
              {?S, ?.} -> [?., ?|, ?.]
              {?|, ?^} -> [?|, ?^, ?|]
              {?|, ?.} -> [?., ?|, ?.]
              {?., ?^} -> [?., ?^, ?.]
              {_, ?.} -> [?., ?., ?.]
            end
          end)
          |> join_chunks(fn chars ->
            if Enum.member?(chars, ?^) do
              ?^
            else
              if Enum.member?(chars, ?|) do
                ?|
              else
                ?.
              end
            end
          end)
          |> Enum.drop(1)
          |> Enum.reverse()

        [tl(new_line) | result]
      end
    end)
    |> Enum.reverse()
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
