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
    {:ok, defender} = Hero.damage(defender, calculate_damage(attacker, attack_result))
    defender
  end

  defp calculate_damage(attacker, attack_result) when attack_result == :hit do
    Hero.attack_damage(attacker)
  end

  defp calculate_damage(attacker, attack_result) when attack_result == :critical do
    Hero.critical_damage(attacker)
  end

  defp armor_class(defender) do
    Hero.armor_class(defender)
  end

  defp adjusted_roll(roll, attacker) do
    roll + Hero.attack_modifier(attacker)
  end

  defp add_experience(attacker, attack_result) when attack_result == :miss do
    attacker
  end

  defp add_experience(attacker, attack_result) do
    {:ok, attacker} = Hero.add_experience(attacker, 10)
    attacker
  end

end
