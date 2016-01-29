defmodule Hero.ArmorClass do

  def armor_class(hero, attacker) do
    case {Hero.class(attacker), Hero.Ability.modifier(hero, :dex)} do
      {:rogue, modifier} when modifier > 0 -> 10
      {_, modifier} -> 10 + modifier
    end
  end

end
