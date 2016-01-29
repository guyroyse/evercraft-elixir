defmodule Attack do

  def attack(attacker, defender, roll) do
    result = Attack.Resolve.resolve(attacker, defender, roll)
    attacker = Attack.Experience.add(attacker, result)
    defender = Attack.Damage.damage(attacker, defender, result)
    {result, attacker, defender}
  end

end

defmodule Attack.Resolve do

  def resolve(attacker, defender, roll) do
    ac = Hero.ArmorClass.armor_class(defender, attacker)
    adjusted = roll + Hero.Attack.modifier(attacker)
    case {ac, adjusted, roll} do
      {_, _, 20} -> :critical
      {ac, adjusted, _} when adjusted >= ac -> :hit
      {_, _, _} -> :miss
    end
  end

end

defmodule Attack.Damage do

  def damage(attacker, defender, result) do
    damage = calculate_damage(attacker, result)
    {:ok, defender} = Hero.HitPoints.damage(defender, damage)
    defender
  end

  defp calculate_damage(_, :miss) do 0 end
  defp calculate_damage(attacker, :hit) do Hero.Attack.damage(attacker) end
  defp calculate_damage(attacker, :critical) do Hero.Attack.critical_damage(attacker) end

end

defmodule Attack.Experience do

  def add(attacker, result) do
    xp = calculate_experience(result)
    {:ok, attacker} = Hero.Experience.add(attacker, xp)
    attacker
  end

  defp calculate_experience(:miss) do 0 end
  defp calculate_experience(_) do 10 end

end
