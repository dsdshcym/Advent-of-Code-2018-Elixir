defmodule Day24Test do
  use ExUnit.Case
  doctest Day24

  @example_input """
  Immune System:
  17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
  989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3

  Infection:
  801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
  4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4
  """

  @puzzle_input """
  Immune System:
  504 units each with 1697 hit points (weak to fire; immune to slashing) with an attack that does 28 fire damage at initiative 4
  7779 units each with 6919 hit points (weak to bludgeoning) with an attack that does 7 cold damage at initiative 2
  7193 units each with 13214 hit points (weak to cold, fire) with an attack that does 12 slashing damage at initiative 14
  1898 units each with 3721 hit points (weak to bludgeoning) with an attack that does 16 cold damage at initiative 20
  843 units each with 3657 hit points (immune to slashing) with an attack that does 41 cold damage at initiative 17
  8433 units each with 3737 hit points (immune to radiation; weak to bludgeoning) with an attack that does 3 bludgeoning damage at initiative 8
  416 units each with 3760 hit points (immune to fire, radiation) with an attack that does 64 radiation damage at initiative 3
  5654 units each with 1858 hit points (weak to fire) with an attack that does 2 cold damage at initiative 6
  2050 units each with 8329 hit points (immune to radiation, cold) with an attack that does 36 radiation damage at initiative 12
  4130 units each with 3560 hit points with an attack that does 8 bludgeoning damage at initiative 13

  Infection:
  442 units each with 35928 hit points with an attack that does 149 bludgeoning damage at initiative 11
  61 units each with 42443 hit points (immune to radiation) with an attack that does 1289 slashing damage at initiative 7
  833 units each with 6874 hit points (weak to slashing) with an attack that does 14 bludgeoning damage at initiative 15
  1832 units each with 61645 hit points with an attack that does 49 fire damage at initiative 9
  487 units each with 26212 hit points (weak to fire) with an attack that does 107 bludgeoning damage at initiative 16
  2537 units each with 18290 hit points (immune to cold, slashing, fire) with an attack that does 11 fire damage at initiative 19
  141 units each with 14369 hit points (immune to bludgeoning) with an attack that does 178 radiation damage at initiative 5
  3570 units each with 34371 hit points with an attack that does 18 radiation damage at initiative 10
  5513 units each with 60180 hit points (weak to radiation, fire) with an attack that does 16 slashing damage at initiative 1
  2378 units each with 20731 hit points (weak to bludgeoning) with an attack that does 17 radiation damage at initiative 18
  """

  describe "part 1" do
    test "example" do
      assert Day24.part_1(@example_input) == 5216
    end

    test "puzzle input" do
      assert Day24.part_1(@puzzle_input) == 16325
    end
  end
end
