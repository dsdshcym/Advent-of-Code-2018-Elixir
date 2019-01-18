defmodule Day24.GroupTest do
  use ExUnit.Case

  alias Day24.Group

  describe "effective_power/1" do
    test "returns the product of units and attack damage" do
      group = Group.create(%{units: 100, attack_damage: 34})

      assert Group.effective_power(group) == 3400
    end
  end

  describe "units/1" do
    test "returns the units of this group" do
      group = Group.create(%{units: 10})

      assert Group.units(group) == 10
    end
  end

  describe "army/1" do
    test "returns the army of this group" do
      group = Group.create(%{army: :immune_system})

      assert Group.army(group) == :immune_system
    end
  end

  describe "initiative/1" do
    test "returns the initiative of this group" do
      group = Group.create(%{initiative: 1})

      assert Group.initiative(group) == 1
    end
  end

  describe "full_damage_if_attack/2" do
    test "returns 0 if defender is immune to attacker's attack type" do
      attacker = Group.create(%{units: 10, attack_damage: 10, attack_type: :fire})
      defender = Group.create(%{immunities: [:fire], weaknesses: []})

      assert Group.full_damage_if_attack(attacker, defender) == 0
    end

    test "returns double of attacker's effective_power if defender is weak to attacker's attack type" do
      attacker = Group.create(%{units: 10, attack_damage: 10, attack_type: :fire})
      defender = Group.create(%{weaknesses: [:fire], immunities: []})

      assert Group.full_damage_if_attack(attacker, defender) == 200
    end

    test "returns attacker's effective_power if defender is neither immune nor weak to attacker's attack type" do
      attacker = Group.create(%{units: 10, attack_damage: 10, attack_type: :fire})
      defender = Group.create(%{weaknesses: [], immunities: []})

      assert Group.full_damage_if_attack(attacker, defender) == 100
    end
  end

  describe "attack/2" do
    test "only reduces whole units from the defender group" do
      attacker = Group.create(%{units: 10, attack_damage: 100, attack_type: :fire})
      defender = Group.create(%{units: 4, hp_per_unit: 300, immunities: [], weaknesses: []})

      :ok = Group.attack(attacker, defender)

      assert Group.units(defender) == 1
    end

    test "reduces no more units than the defender has" do
      attacker = Group.create(%{units: 20, attack_damage: 100, attack_type: :fire})
      defender = Group.create(%{units: 4, hp_per_unit: 300, immunities: [], weaknesses: []})

      :ok = Group.attack(attacker, defender)

      assert Group.units(defender) == 0
    end
  end
end
