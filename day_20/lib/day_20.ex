defmodule Day20 do
  @moduledoc """
  Documentation for Day20.
  """


  def parse_input(string) do
    path_size = byte_size(string) - 2

    <<"^", path_string::binary-size(path_size), "$">> = string

    parse_path(path_string, [])
  end

  defp parse_path(input, acc, branches \\ [], stack \\ [])

  defp parse_path("N" <> rest, acc, branches, stack) do
    parse_path(rest, [:north | acc], branches, stack)
  end

  defp parse_path("W" <> rest, acc, branches, stack) do
    parse_path(rest, [:west | acc], branches, stack)
  end

  defp parse_path("S" <> rest, acc, branches, stack) do
    parse_path(rest, [:south | acc], branches, stack)
  end

  defp parse_path("E" <> rest, acc, branches, stack) do
    parse_path(rest, [:east | acc], branches, stack)
  end

  defp parse_path("(" <> rest, acc, branches, stack) do
    parse_path(rest, [], [], [{acc, branches} | stack])
  end

  defp parse_path(")" <> rest, current_branch, branches, [{acc, prev_branches} | stack]) do
    branches = [Enum.reverse(current_branch) | branches] |> Enum.reverse()

    parse_path(rest, [branches | acc], prev_branches, stack)
  end

  defp parse_path("|" <> rest, current_branch, branches, stack) do
    parse_path(rest, [], [Enum.reverse(current_branch) | branches], stack)
  end

  defp parse_path("", acc, [], []) do
    Enum.reverse(acc)
  end
end
