defmodule Hero.ArmorClass do

  def armor_class(hero) do
    10 + Hero.Ability.modifier(hero, :dex)
  end

end
