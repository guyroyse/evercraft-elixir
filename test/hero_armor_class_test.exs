defmodule HeroArmorClassTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create(), attacker: Hero.create() }
  end

  ## armor class
  test "it has default armor class of 10", context do
    assert Hero.ArmorClass.armor_class(context[:subject], context[:attacker]) == 10
  end
  test "it adds dex modifier to armor class", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :dex, 15)
    assert Hero.ArmorClass.armor_class(hero, context[:attacker]) == 12
  end

  ## armor class - when attacker is a rogue
  test "when attacker is a rogue, it ignores opponent's positive dex modifier to armor class", context do
    {:ok, attacker} = Hero.class(context[:attacker], :rogue)
    {:ok, hero} = Hero.Ability.score(context[:subject], :dex, 20)  ## armor class = 15
    assert Hero.ArmorClass.armor_class(hero, attacker) == 10
  end
  test "when attacker is a rogue, it does not ignore opponent's negative dex modifier to armor class", context do
    {:ok, attacker} = Hero.class(context[:attacker], :rogue)
    {:ok, hero} = Hero.Ability.score(context[:subject], :dex, 5)  ## armor class = 7
    assert Hero.ArmorClass.armor_class(hero, attacker) == 7
  end

end
