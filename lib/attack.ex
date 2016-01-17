defmodule Attack do
  def attack(attacker, defender, roll) do
    result = attack_result(defender, roll)
    defender = damage(defender, result)
    {result, attacker, defender}
  end

  defp attack_result(defender, roll) do
    case {Hero.armor_class(defender), roll} do
      {_, roll} when roll == 20 -> :critical
      {ac, roll} when roll >= ac -> :hit
      {_, _} -> :miss
    end
  end

  defp damage(defender, attack_result) when attack_result == :miss do
    defender
  end

  defp damage(defender, attack_result) when attack_result == :hit do
    {:ok, defender} = Hero.damage(defender, 1)
    defender
  end

  defp damage(defender, attack_result) when attack_result == :critical do
    {:ok, defender} = Hero.damage(defender, 2)
    defender
  end

end
