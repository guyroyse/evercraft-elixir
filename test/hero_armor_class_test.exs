defmodule HeroArmorClassTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create() }
  end

  ## armor class
  test "it has default armor class of 10", context do
    assert Hero.ArmorClass.armor_class(context[:subject]) == 10
  end
  test "it adds dex modifier to armor class", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :dex, 15)
    assert Hero.ArmorClass.armor_class(hero) == 12
  end

end
