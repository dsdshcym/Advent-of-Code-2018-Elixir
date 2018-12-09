defmodule Alchemical do
  defguardp react?(c1, c2) when abs(c1 - c2) == ?a - ?A

  def shortest_length(units) do
    all_units =
      units
      |> Enum.map(&downcase/1)
      |> Enum.uniq()

    all_possible_inputs =
      all_units
      |> Enum.map(fn
        unit ->
          Enum.reject(units, fn c -> downcase(c) == unit end)
      end)

    all_possible_results =
      all_possible_inputs
      |> Enum.map(&reduce/1)

    all_possible_results
    |> Enum.min_by(&length/1)
    |> length()
  end

  defp downcase(c) when c in ?a..?z, do: c
  defp downcase(c) when c in ?A..?Z, do: c + (?a - ?A)

  def reduce(units) do
    reduce(units, [])
  end

  defp reduce([c1, c2 | rest], []) when react?(c1, c2) do
    reduce(rest, [])
  end

  defp reduce([c1, c2 | rest], [pre | stack]) when react?(c1, c2) do
    reduce([pre | rest], stack)
  end

  defp reduce('', stack) do
    Enum.reverse(stack)
  end

  defp reduce([c | rest], stack) do
    reduce(rest, [c | stack])
  end
end

ExUnit.start()

defmodule AlchemicalTest do
  use ExUnit.Case

  @input File.read!("./fixtures/day_5.txt")
         |> String.trim()
         |> String.to_charlist()

  describe "shortest_length/1" do
    test "example" do
      assert Alchemical.shortest_length('dabAcCaCBAcCcaDA') == 4
    end

    test "puzzle input" do
      assert Alchemical.shortest_length(@input) == 4652
    end
  end

  describe "reduce/1" do
    test "changes nothing for an empty string" do
      assert Alchemical.reduce('') == ''
    end

    test "destroys nothing" do
      assert Alchemical.reduce('abCdEff') == 'abCdEff'
    end

    test "destroys two adjacent units of the same type and opposite polarity" do
      assert Alchemical.reduce('aA') == ''
    end

    test "does nothing to two adjacent units of the different type and opposite polarity" do
      assert Alchemical.reduce('aB') == 'aB'
    end

    test "destroys in the middle" do
      assert Alchemical.reduce('dbaAce') == 'dbce'
    end

    test "reduces recursively" do
      assert Alchemical.reduce('aBbA') == ''
    end

    test "example" do
      assert Alchemical.reduce('dabAcCaCBAcCcaDA') == 'dabCBAcaDA'
    end

    test "part 1" do
      assert @input
             |> Alchemical.reduce()
             |> length() == 11668
    end
  end
end
