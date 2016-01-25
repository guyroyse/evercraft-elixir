defmodule Attack do
  def attack(attacker, defender, roll) do
    result = attack_result(attacker, defender, roll)
    defender = damage(attacker, defender, result)
    attacker = add_experience(attacker, result)
    {result, attacker, defender}
  end

  defp attack_result(attacker, defender, roll) do
    case {armor_class(defender), adjusted_roll(roll, attacker), roll} do
      {_, _, 20} -> :critical
      {ac, roll, _} when roll >= ac -> :hit
      {_, _, _} -> :miss
    end
  end

  defp damage(_, defender, attack_result) when attack_result == :miss do
    defender
  end

  defp damage(attacker, defender, attack_result) do
    {:ok, defender} = Hero.HitPoints.damage(defender, calculate_damage(attacker, attack_result))
    defender
  end

  defp calculate_damage(attacker, attack_result) when attack_result == :hit do
    Hero.Attack.damage(attacker)
  end

  defp calculate_damage(attacker, attack_result) when attack_result == :critical do
    Hero.Attack.critical_damage(attacker)
  end

  defp armor_class(defender) do
    Hero.armor_class(defender)
  end

  defp adjusted_roll(roll, attacker) do
    roll + Hero.Attack.modifier(attacker)
  end

  defp add_experience(attacker, attack_result) when attack_result == :miss do
    attacker
  end

  defp add_experience(attacker, attack_result) do
    {:ok, attacker} = Hero.Experience.add(attacker, 10)
    attacker
  end

end
