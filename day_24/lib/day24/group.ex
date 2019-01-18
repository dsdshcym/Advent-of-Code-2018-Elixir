defmodule Day24.Group do
  use GenServer

  def create(state) do
    {:ok, pid} = GenServer.start_link(__MODULE__, state)
    pid
  end

  def units(pid) do
    GenServer.call(pid, :units)
  end

  def army(pid) do
    GenServer.call(pid, :army)
  end

  def initiative(pid) do
    GenServer.call(pid, :initiative)
  end

  def effective_power(pid) do
    GenServer.call(pid, :effective_power)
  end

  def full_damage_if_attack(attacker_pid, defender_pid) do
    GenServer.call(attacker_pid, {:full_damage_if_attack, defender_pid})
  end

  def attack(attacker_pid, defender_pid) do
    GenServer.call(attacker_pid, {:attack, defender_pid})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:units, _from, state) do
    {:reply, state.units, state}
  end

  def handle_call(:army, _from, state) do
    {:reply, state.army, state}
  end

  def handle_call(:initiative, _from, state) do
    {:reply, state.initiative, state}
  end

  def handle_call(:effective_power, _from, state) do
    {:reply, calc_effective_power(state), state}
  end

  def handle_call({:full_damage_if_attack, defender_pid}, _from, state) do
    attack = summon_attack(state)
    damage_amount = GenServer.call(defender_pid, {:inflicated_damage_if_attacked_by, attack})

    {:reply, damage_amount, state}
  end

  def handle_call({:attack, defender_pid}, _from, state) do
    attack = summon_attack(state)
    :ok = GenServer.call(defender_pid, {:absorb_attack, attack})

    {:reply, :ok, state}
  end

  def handle_call({:inflicated_damage_if_attacked_by, attack}, _from, state) do
    {:reply, damage_amount(state, attack), state}
  end

  def handle_call({:absorb_attack, attack}, _from, state) do
    damage_amount = damage_amount(state, attack)
    killed_units = Enum.min([state.units, div(damage_amount, state.hp_per_unit)])
    remained_units = state.units - killed_units

    {:reply, :ok, %{state | units: remained_units}}
  end

  defp calc_effective_power(state) do
    state.units * state.attack_damage
  end

  defp summon_attack(state) do
    %{
      type: state.attack_type,
      total_amount: calc_effective_power(state)
    }
  end

  defp damage_amount(state, attack) do
    cond do
      attack.type in state.immunities -> 0
      attack.type in state.weaknesses -> 2 * attack.total_amount
      true -> attack.total_amount
    end
  end
end
