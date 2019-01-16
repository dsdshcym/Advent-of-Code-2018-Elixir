defmodule Day23 do
  def part_1(input) do
    input
    |> parse()
    |> nanobots_count_in_range_of_the_strongest()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_nanobot/1)
  end

  @coordinate "-?[0-9]+"
  @radius "[0-9]+"

  @regexp ~r/^pos=<(?<x>#{@coordinate}),(?<y>#{@coordinate}),(?<z>#{@coordinate})>, r=(?<r>#{
            @radius
          })$/
  defp parse_nanobot(line) do
    [^line | captures] = Regex.run(@regexp, line)
    [x, y, z, r] = Enum.map(captures, &String.to_integer/1)

    %{coordinates: {x, y, z}, r: r}
  end

  defp nanobots_count_in_range_of_the_strongest(nanobots) do
    nanobots
    |> strongest()
    |> in_range_of(nanobots)
    |> Enum.count()
  end

  defp strongest(nanobots) do
    nanobots
    |> Enum.max_by(& &1.r)
  end

  defp in_range_of(nanobot, nanobots) do
    nanobots
    |> Enum.filter(&in_range?(nanobot, &1))
  end

  defp in_range?(bot1, bot2) do
    manhattan_distance(bot1, bot2) <= bot1.r
  end

  defp manhattan_distance(bot1, bot2) do
    {x1, y1, z1} = bot1.coordinates
    {x2, y2, z2} = bot2.coordinates

    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end
end
