defmodule Alchemical do
  def reduce_recursively(units) do
    reduced_units = reduce(units)

    if reduced_units == units do
      units
    else
      reduce_recursively(reduced_units)
    end
  end

  def reduce(units) do
    reduce(units, [])
  end

  defp reduce('', stack) do
    Enum.reverse(stack)
  end

  defp reduce([c], stack) do
    reduce('', [c | stack])
  end

  defp reduce([c1, c2 | rest], stack) do
    if react?(c1, c2) do
      Enum.reverse(stack) ++ rest
    else
      reduce([c2 | rest], [c1 | stack])
    end
  end

  defp react?(c1, c2) do
    abs(c1 - c2) == ?a - ?A
  end
end

ExUnit.start()

defmodule AlchemicalTest do
  use ExUnit.Case

  describe "reduce_recursively/1" do
    test "reduces recursively" do
      assert Alchemical.reduce_recursively('aBbA') == ''
    end

    test "example" do
      assert Alchemical.reduce_recursively('dabAcCaCBAcCcaDA') == 'dabCBAcaDA'
    end

    test "part 1" do
      assert File.read!("./fixtures/day_5.txt")
             |> String.trim()
             |> String.to_charlist()
             |> Alchemical.reduce_recursively()
             |> length() == 11668
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
  end
end
