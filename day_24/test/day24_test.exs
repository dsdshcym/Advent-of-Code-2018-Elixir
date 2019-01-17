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

  describe "part 1" do
    test "example" do
      assert Day24.part_1(@example_input) == 5216
    end
  end

  describe "parse/1" do
    test "example" do
      assert Day24.parse(@example_input) ==
               %{
                 immune_system: [
                   %{
                     units: 17,
                     hp_per_unit: 5390,
                     weaknesses: [:radiation, :bludgeoning],
                     immunities: [],
                     attack_damage: 4507,
                     attack_type: :fire,
                     initiative: 2
                   },
                   %{
                     units: 989,
                     hp_per_unit: 1274,
                     weaknesses: [:bludgeoning, :slashing],
                     immunities: [:fire],
                     attack_damage: 25,
                     attack_type: :slashing,
                     initiative: 3
                   }
                 ],
                 infection: [
                   %{
                     units: 801,
                     hp_per_unit: 4706,
                     weaknesses: [:radiation],
                     immunities: [],
                     attack_damage: 116,
                     attack_type: :bludgeoning,
                     initiative: 1
                   },
                   %{
                     units: 4485,
                     hp_per_unit: 2961,
                     weaknesses: [:fire, :cold],
                     immunities: [:radiation],
                     attack_damage: 12,
                     attack_type: :slashing,
                     initiative: 4
                   }
                 ]
               }
    end
  end

  describe "parse_group/1" do
    test "get units from \"xxx units\"" do
      assert %{units: 17} =
               Day24.parse_group(
                 "17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets hp_per_unit from \"xxx hit points\"" do
      assert %{hp_per_unit: 5390} =
               Day24.parse_group(
                 "17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "sets weaknesses to empty list when there are no weakness specifications" do
      assert %{weaknesses: []} =
               Day24.parse_group(
                 "17 units each with 5390 hit points with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets weaknesses info from \"(weak to a)\"" do
      assert %{weaknesses: [:radiation]} =
               Day24.parse_group(
                 "17 units each with 5390 hit points (weak to radiation) with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets weaknesses info from \"(weak to a, b)\"" do
      assert %{weaknesses: [:radiation, :bludgeoning]} =
               Day24.parse_group(
                 "17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "sets immunities to empty list when there are no immunity specifications" do
      assert %{immunities: []} =
               Day24.parse_group(
                 "17 units each with 5390 hit points with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets immunities info from \"(immune to a)\"" do
      assert %{immunities: [:fire]} =
               Day24.parse_group(
                 "17 units each with 5390 hit points (immune to fire) with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets immunities info from \"(immune to a, b)\"" do
      assert %{immunities: [:fire, :cold]} =
               Day24.parse_group(
                 "17 units each with 5390 hit points (immune to fire, cold) with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets weaknesses and immunities info from \"(weak to a; immune to b)\"" do
      assert %{weaknesses: [:fire], immunities: [:cold]} =
               Day24.parse_group(
                 "17 units each with 5390 hit points (weak to fire; immune to cold) with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets attack damage from \"xxx <attack_type> damage\"" do
      assert %{attack_damage: 4507} =
               Day24.parse_group(
                 "17 units each with 5390 hit points with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets attack type from \"<attack_damage> xxx damage\"" do
      assert %{attack_type: :fire} =
               Day24.parse_group(
                 "17 units each with 5390 hit points with an attack that does 4507 fire damage at initiative 2"
               )
    end

    test "gets initiative from \"initiative xxx\"" do
      assert %{initiative: 2} =
               Day24.parse_group(
                 "17 units each with 5390 hit points with an attack that does 4507 fire damage at initiative 2"
               )
    end
  end
end
