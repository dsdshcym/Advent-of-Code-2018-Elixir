defmodule Claim do
  def new(options) do
    %{
      id: options[:id],
      x: options[:x],
      y: options[:y],
      width: options[:width],
      height: options[:height]
    }
  end

  def all_points(claim) do
    for x <- claim.x..(claim.x + claim.width - 1),
        y <- claim.y..(claim.y + claim.height - 1) do
      {x, y}
    end
  end
end

defmodule Fabric do
  def overlap_size(inputs) do
    inputs
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, fn
      claim, fabric ->
        claim_area(fabric, claim)
    end)
    |> Enum.count(fn {_point, claimed_times} -> claimed_times >= 2 end)
  end

  defp parse_line(line) do
    Regex.named_captures(
      ~r/#(?<id>[0-9]+) @ (?<x>[0-9]+),(?<y>[0-9]+): (?<width>[0-9]+)x(?<height>[0-9]+)/,
      line
    )
    |> Enum.map(fn {key, value} -> {String.to_atom(key), String.to_integer(value)} end)
    |> Claim.new()
  end

  defp claim_area(fabric, claim) do
    claim
    |> Claim.all_points()
    |> Enum.reduce(fabric, fn point, fabric ->
      Map.update(fabric, point, 1, &(&1 + 1))
    end)
  end
end

ExUnit.start()

defmodule FabricTest do
  use ExUnit.Case

  describe "overlap_size/1" do
    test "returns 0 for only one claim" do
      assert Fabric.overlap_size("#123 @ 3,2: 5x4") == 0
    end

    test ~S(
    .....
    .11..
    .1x2.
    ..22.
    ) do
      assert """
             #1 @ 1,2: 2x2
             #2 @ 2,3: 2x2
             """
             |> Fabric.overlap_size() == 1
    end

    test ~S(
    ..22.
    .1#x.
    .1x3.
    .....
    ) do
      assert """
             #1 @ 1,1: 2x2
             #2 @ 2,0: 2x2
             #3 @ 2,1: 2x2
             """
             |> Fabric.overlap_size() == 3
    end

    test ~S(
    ........
    ........
    ........
    .1111...
    .1111...
    .111122.
    .111122.
    ) do
      assert """
             #1 @ 1,3: 4x4
             #2 @ 5,5: 2x2
             """
             |> Fabric.overlap_size() == 0
    end

    test "puzzle input" do
      assert File.read!("./fixtures/day_3.txt")
             |> Fabric.overlap_size() == 120_419
    end
  end
end
