defmodule Attack do
  def attack(attacker, defender, roll) do
    result = case {Hero.armor_class(defender), roll} do
      {ac, roll} when roll >= ac -> :hit
      {_, _} -> :miss
    end
    {result, attacker, defender}
  end
end
