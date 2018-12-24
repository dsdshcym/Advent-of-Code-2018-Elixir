defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  describe "part 1" do
    test "example input" do
      input = """
      #ip 0
      seti 5 0 1
      seti 6 0 2
      addi 0 1 0
      addr 1 2 3
      setr 1 0 0
      seti 8 0 4
      seti 9 0 5
      """

      assert %{registers: [6, 5, 6, 0, 0, 9]} = Day19.part_1(input)
    end
  end

  describe "parse_input/1" do
    test "sets ip_register based on line 1" do
      assert %{ip_register: 3} = Day19.parse_input("#ip 3")
    end

    test "sets program based on rest inputs" do
      input = """
      #ip 4
      addi 5 2 9
      setr 8 7 4
      """

      assert %{
               program: [
                 %{operation: :addi, A: 5, B: 2, C: 9},
                 %{operation: :setr, A: 8, B: 7, C: 4}
               ]
             } = Day19.parse_input(input)
    end

    test "sets registers to [0, 0, 0, 0, 0, 0]" do
      assert %{registers: [0, 0, 0, 0, 0, 0]} = Day19.parse_input("#ip 0")
    end

    test "example input" do
      input = """
      #ip 0
      seti 5 0 1
      seti 6 0 2
      addi 0 1 0
      addr 1 2 3
      setr 1 0 0
      seti 8 0 4
      seti 9 0 5
      """

      assert Day19.parse_input(input) ==
               %{
                 ip_register: 0,
                 program: [
                   %{operation: :seti, A: 5, B: 0, C: 1},
                   %{operation: :seti, A: 6, B: 0, C: 2},
                   %{operation: :addi, A: 0, B: 1, C: 0},
                   %{operation: :addr, A: 1, B: 2, C: 3},
                   %{operation: :setr, A: 1, B: 0, C: 0},
                   %{operation: :seti, A: 8, B: 0, C: 4},
                   %{operation: :seti, A: 9, B: 0, C: 5}
                 ],
                 registers: [0, 0, 0, 0, 0, 0]
               }
    end
  end
end
