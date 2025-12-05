defmodule AocElixir do
  @moduledoc """
  Utilities for all advent of code.
  """

  def read_input(num) when is_number(num) do
    String.trim(File.read!(~s"./inputs/day_#{num}.txt"))
  end

  def read_input_stream(num) when is_number(num) do
    File.stream!(~s"./inputs/day_#{num}.txt")
  end
end
