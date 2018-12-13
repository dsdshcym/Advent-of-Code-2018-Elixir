defmodule LicenseFile do
  def parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> do_parse()
  end

  defp do_parse([children_num, metadata_num | leftover]) do
    {children, leftover} =
      case children_num do
        0 ->
          {[], leftover}

        children_num ->
          Enum.map_reduce(1..children_num, leftover, fn
            _, leftover -> do_parse(leftover)
          end)
      end

    {metadata, leftover} = Enum.split(leftover, metadata_num)

    {%{children: children, metadata: metadata}, leftover}
  end

  def tree_metadata_sum(tree) do
    children_metadata_sum = tree.children |> Enum.map(&tree_metadata_sum/1) |> Enum.sum()
    self_metadata_sum = tree.metadata |> Enum.sum()

    children_metadata_sum + self_metadata_sum
  end
end

ExUnit.start()

defmodule LicenseFileTest do
  use ExUnit.Case

  @input File.stream!("./fixtures/day_8.txt") |> Enum.at(0)

  describe "part 1" do
    test "example" do
      input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"

      {tree, []} =
        input
        |> LicenseFile.parse()

      assert tree |> LicenseFile.tree_metadata_sum() == 138
    end

    test "puzzle input" do
      {tree, []} =
        @input
        |> LicenseFile.parse()

      assert tree |> LicenseFile.tree_metadata_sum() == 47112
    end
  end

  describe "parse/1" do
    test "0 chilren, 0 metadata entries" do
      assert {%{children: [], metadata: []}, []} = LicenseFile.parse("0 0")
    end

    test "0 children, 2 metadata entries" do
      assert {%{children: [], metadata: [1, 2]}, []} = LicenseFile.parse("0 2 1 2")
    end

    test "1 children, 2 metadata entries" do
      assert {
               %{
                 children: [%{children: [], metadata: []}],
                 metadata: [3, 4]
               },
               []
             } = LicenseFile.parse("1 2 0 0 3 4")
    end

    test "build children recursively" do
      assert {
               %{
                 children: [
                   %{
                     children: [%{children: [], metadata: []}],
                     metadata: []
                   }
                 ],
                 metadata: []
               },
               []
             } = LicenseFile.parse("1 0 1 0 0 0")
    end
  end

  describe "tree_metadata_sum/1" do
    test "returns sum of all metadata entries from all nodes" do
      tree = %{
        children: [
          %{children: [], metadata: [1]},
          %{children: [%{children: [], metadata: [3]}], metadata: [2]}
        ],
        metadata: [4, 5]
      }

      assert LicenseFile.tree_metadata_sum(tree) == 15
    end
  end
end
