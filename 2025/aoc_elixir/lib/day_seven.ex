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

  # vals: {upper_char, lower_char}
  def advance_beam(vals) do
    case vals do
      {?S, ?.} -> [?., ?|, ?.]
      {?|, ?^} -> [?|, ?^, ?|]
      {?|, ?.} -> [?., ?|, ?.]
      {?., ?^} -> [?., ?^, ?.]
      {_, ?.} -> [?., ?., ?.]
    end
  end

  def choose_char_from_options(list_of_chars) do
    cond do
      Enum.member?(list_of_chars, ?^) -> ?^
      Enum.member?(list_of_chars, ?|) -> ?|
      Enum.member?(list_of_chars, ?.) -> ?.
    end
  end

  def simulate_beam(input_lines) do
    input_lines
    |> Enum.reduce([], fn line, result ->
      if Enum.empty?(result) do
        [line | result]
      else
        prev_line = hd(result)

        new_line =
          Enum.zip(prev_line, line)
          |> Enum.map(&advance_beam/1)
          |> join_chunks(&choose_char_from_options/1)
          # because we're generating 3-tuples for each char, we need to remove the first and last generated, which are not collapsed by join_chunks
          |> Enum.drop(1)
          # we're building in reverse because of linked lists, so reverse
          |> Enum.reverse()

        [tl(new_line) | result]
      end
    end)
    # we're building in reverse because of linked lists, so reverse
    |> Enum.reverse()
  end

  def count_splits(input_lines) do
    input_lines
    # columnwise
    |> Enum.zip()
    |> Enum.map(fn col ->
      sliding_window_chunks(Tuple.to_list(col), 2)
      |> Enum.count(fn [upper, lower] -> upper === ?| and lower === ?^ end)
    end)
    |> Enum.sum()
  end

  def part1(input_lines) do
    input_lines
    |> simulate_beam()
    |> count_splits()
  end

  ### PART 2 ###

  # vals: {upper_char, lower_char}
  def advance_quantum_beam(vals) do
    case vals do
      {?S, ?.} -> [[?., ?|, ?.]]
      {?|, ?^} -> [[?|, ?^, ?.], [?., ?^, ?|]]
      {?|, ?.} -> [[?., ?|, ?.]]
      {?., ?^} -> [[?., ?^, ?.]]
      {_, ?.} -> [[?., ?., ?.]]
    end
  end

  def permutations(list_of_lists) do
    Enum.reduce(Enum.reverse(list_of_lists), [[]], fn options, permutations ->
      Enum.flat_map(options, fn option ->
        Enum.map(permutations, fn permutation ->
          [option | permutation]
        end)
      end)
    end)
  end

  def simulate_quantum_beam(input_lines) do
    input_lines
    |> Enum.reduce([], fn line, results ->
      if Enum.empty?(results) do
        [{[line], 1}]
      else
        new_results =
          Enum.flat_map(results, fn {result_lines, sources} ->
            prev_line = hd(result_lines)

            new_quantum_lines =
              Enum.zip(prev_line, line)
              |> Enum.map(&advance_quantum_beam/1)
              |> permutations()
              |> Enum.map(fn permutation ->
                permutation
                |> join_chunks(&choose_char_from_options/1)
                # because we're generating 3-tuples for each char, we need to remove the first and last generated, which are not collapsed by join_chunks
                |> Enum.drop(1)
                # we're building in reverse because of linked lists, so reverse
                |> Enum.reverse()
                |> Enum.drop(1)
              end)

            Enum.map(new_quantum_lines, fn new_line -> {[new_line | result_lines], sources} end)
          end)

        new_results
        |> Enum.uniq_by(fn {result_lines, _} -> hd(result_lines) end)
        |> Enum.map(fn {result_lines, _} ->
          {result_lines,
           Enum.filter(new_results, fn res -> hd(elem(res, 0)) === hd(result_lines) end)
           |> Enum.sum_by(&elem(&1, 1))}
        end)
      end
    end)
    # we're building in reverse because of linked lists, so reverse
    |> Enum.map(fn {result_lines, sources} -> {Enum.reverse(result_lines), sources} end)
  end

  def part2(input) do
    input
    |> simulate_quantum_beam()
    |> Enum.sum_by(fn {_, sources} -> sources end)
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
