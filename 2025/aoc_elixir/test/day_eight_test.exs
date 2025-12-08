defmodule DayEightTest do
  use ExUnit.Case
  doctest DayEight

  import DayEight

  def demo_input(),
    do: [
      {162, 817, 812},
      {57, 618, 57},
      {906, 360, 560},
      {592, 479, 940},
      {352, 342, 300},
      {466, 668, 158},
      {542, 29, 236},
      {431, 825, 988},
      {739, 650, 466},
      {52, 470, 668},
      {216, 146, 977},
      {819, 987, 18},
      {117, 168, 530},
      {805, 96, 715},
      {346, 949, 466},
      {970, 615, 88},
      {941, 993, 340},
      {862, 61, 35},
      {984, 92, 344},
      {425, 690, 689}
    ]

  test "demo distance" do
    assert hd(shortest_distances(demo_input())) ===
             {{162, 817, 812}, {425, 690, 689}}
  end

  test "demo p1" do
    assert part1(demo_input(), 10) === 40
  end

  test "solve p1" do
    assert part1(parse()) === 79056
  end

  test "solve p2" do
    assert part2(parse()) === 4_639_477
  end
end
