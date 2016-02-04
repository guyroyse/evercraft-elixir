defmodule Hero.ArmorClass do

  def armor_class(hero, attacker) do
    case {Hero.class(attacker), base_armor_class(hero), dex_modifier(hero)} do
      {:rogue, ac, modifier} when modifier > 0 -> ac
      {_, ac, modifier} -> ac + modifier
    end
  end

  defp base_armor_class(hero) do
    case Hero.race(hero) do
      :orc -> 12
      _ -> 10
    end
  end

  defp dex_modifier(hero) do
    Hero.Ability.modifier(hero, :dex)
  end

end
