defmodule HeroTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create() }
  end

  ## name
  test "it has a default name of empty string", context do
    assert Hero.name(context[:subject]) == ""
  end
  test "it has a settable name", context do
    {:ok, hero} = Hero.name(context[:subject], "Bob the Barbarian")
    assert Hero.name(hero) == "Bob the Barbarian"
  end

  ## alignment
  test "it has a default alignment of neutral", context do
    assert Hero.alignment(context[:subject]) == :neutral
  end
  test "it can be good", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    assert Hero.alignment(hero) == :good
  end
  test "it can be neutral", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.alignment(hero, :neutral)
    assert Hero.alignment(hero) == :neutral
  end
  test "it can be evil", context do
    {:ok, hero} = Hero.alignment(context[:subject], :evil)
    assert Hero.alignment(hero) == :evil
  end
  test "it cannot be invalid", context do
    {:error, reason} = Hero.alignment(context[:subject], :emo)
    assert reason == "invalid alignment"
  end

  ## armor class
  test "it has default armor class of 10", context do
    assert Hero.armor_class(context[:subject]) == 10
  end
  test "it adds dex modifier to armor class", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :dex, 15)
    assert Hero.armor_class(hero) == 12
  end

  ## experience points
  test "it has default xp of 0", context do
    assert Hero.experience(context[:subject]) == 0
  end
  test "experience can be added to", context do
    {:ok, hero} = Hero.add_experience(context[:subject], 25)
    {:ok, hero} = Hero.add_experience(hero, 25)
    assert Hero.experience(hero) == 50
  end

  ## level
  test "it has a defauilt level of 1", context do
    assert Hero.level(context[:subject]) == 1
  end
  test "it goes up a level every 1000 experience points", context do
    Enum.each([{999, 1}, {1000, 2}, {1999, 2}, {2000, 3}], fn({xp, level}) ->
      {:ok, hero} = Hero.add_experience(context[:subject], xp)
      assert Hero.level(hero) == level
    end)
  end

end
