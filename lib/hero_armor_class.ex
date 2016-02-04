defmodule Hero.ArmorClass do

  def armor_class(hero, attacker) do
    case {Hero.class(attacker), Hero.race(hero), Hero.Ability.modifier(hero, :dex)} do
      {:rogue, :orc, modifier} when modifier > 0 -> 12
      {:rogue, _, modifier} when modifier > 0 -> 10
      {_, :orc, modifier} -> 12 + modifier
      {_, _, modifier} -> 10 + modifier
    end
  end

end
