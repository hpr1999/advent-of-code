defmodule DaySixTest do
  use ExUnit.Case
  doctest DaySix
  import DaySix

  test "parse" do
    input =
      [
        "123 328  51 64 ",
        " 45 64  387 23 ",
        "  6 98  215 314",
        "*   +   *   +  "
      ]

    assert parse(input) ===
             {[
                "123 328  51 64 ",
                " 45 64  387 23 ",
                "  6 98  215 314"
              ], [&Kernel.*/2, &Kernel.+/2, &Kernel.*/2, &Kernel.+/2]}
  end

  test "p1 demo" do
    input =
      [
        "123 328  51 64 ",
        " 45 64  387 23 ",
        "  6 98  215 314",
        "*   +   *   +  "
      ]

    assert part1(parse(input)) === 4_277_556
  end

  test "p1 solve" do
    assert part1(parse()) === 4_951_502_530_386
  end

  test "p2 demo" do
    input =
      [
        "123 328  51 64 ",
        " 45 64  387 23 ",
        "  6 98  215 314",
        "*   +   *   +  "
      ]

    assert part2(parse(input)) === 3_263_827
  end

  test "p2 solve" do
    assert part2(parse()) === 8_486_156_119_946
  end
end
