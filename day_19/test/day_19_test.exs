defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  @puzzle_input """
  #ip 3
  addi 3 16 3
  seti 1 8 4
  seti 1 4 5
  mulr 4 5 1
  eqrr 1 2 1
  addr 1 3 3
  addi 3 1 3
  addr 4 0 0
  addi 5 1 5
  gtrr 5 2 1
  addr 3 1 3
  seti 2 1 3
  addi 4 1 4
  gtrr 4 2 1
  addr 1 3 3
  seti 1 3 3
  mulr 3 3 3
  addi 2 2 2
  mulr 2 2 2
  mulr 3 2 2
  muli 2 11 2
  addi 1 3 1
  mulr 1 3 1
  addi 1 17 1
  addr 2 1 2
  addr 3 0 3
  seti 0 3 3
  setr 3 0 1
  mulr 1 3 1
  addr 3 1 1
  mulr 3 1 1
  muli 1 14 1
  mulr 1 3 1
  addr 2 1 2
  seti 0 8 0
  seti 0 9 3
  """

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

    test "puzzle input" do
      assert %{registers: [920 | _]} = Day19.part_1(@puzzle_input)
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

    test "sets ip to 0" do
      assert %{ip: 0} = Day19.parse_input("#ip 2")
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
                 registers: [0, 0, 0, 0, 0, 0],
                 ip: 0
               }
    end
  end

  describe "execute_until_ip_is_out_of_bounds/1" do
    test "returns state immediately if ip is equal to or larger than program length" do
      state = %{ip: 1, program: [:any_program]}

      assert Day19.execute_until_ip_is_out_of_bounds(state) == state
    end

    test "executes until ip is out of bounds" do
      init_state = %{
        ip_register: 0,
        ip: 0,
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

      assert %{ip: 7, registers: [6, 5, 6, 0, 0, 9]} =
               Day19.execute_until_ip_is_out_of_bounds(init_state)
    end
  end

  describe "execute/1" do
    test "sets the ip_register to ip first" do
      assert %{registers: [_, 0]} =
               Day19.execute(%{
                 ip_register: 1,
                 ip: 0,
                 program: [%{operation: :seti, A: 5, B: 5, C: 0}],
                 registers: [0, 9]
               })
    end

    test "executes the instruction ip points to" do
      assert %{registers: [2, _ip_register]} =
               Day19.execute(%{
                 ip_register: 1,
                 ip: 0,
                 program: [%{operation: :seti, A: 2, B: 5, C: 0}],
                 registers: [0, 0]
               })
    end

    test "sets ip to the value of ip_register after the execution and increased by 1" do
      assert %{ip: 3} =
               Day19.execute(%{
                 ip_register: 0,
                 ip: 0,
                 program: [%{operation: :seti, A: 2, B: nil, C: 0}],
                 registers: [0, 0]
               })
    end

    test "does not modify state.program" do
      assert %{program: [%{operation: :seti, A: 2, B: nil, C: 0}]} =
               Day19.execute(%{
                 ip_register: 0,
                 ip: 0,
                 program: [%{operation: :seti, A: 2, B: nil, C: 0}],
                 registers: [0, 0]
               })
    end
  end
end
