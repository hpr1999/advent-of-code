defmodule AocElixir do
  @moduledoc """
  Utilities for all advent of code.
  """

  def read_input(num), do: File.read!(~s"./inputs/day_#{num}.txt")
  def read_lines(num), do: read_input(num) |> String.split("\n") |> Enum.drop(-1)
end
