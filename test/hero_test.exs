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

  ## class
  test "it has a default class of :no_class", context do
    assert Hero.class(context[:subject]) == :no_class
  end
  test "it can be classless", context do
    {:ok, hero} = Hero.class(context[:subject], :fighter)
    {:ok, hero} = Hero.class(hero, :no_class)
    assert Hero.class(hero) == :no_class
  end
  test "it can be a fighter", context do
    {:ok, hero} = Hero.class(context[:subject], :fighter)
    assert Hero.class(hero) == :fighter
  end
  test "it can be a rogue", context do
    {:ok, hero} = Hero.class(context[:subject], :rogue)
    assert Hero.class(hero) == :rogue
  end

  ## class - invalid classes
  test "it cannot be an invalid class", context do
    {:error, reason} = Hero.class(context[:subject], :poser)
    assert reason == "invalid class"
  end
  test "it cannot be a rogue if it is good", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:error, reason} = Hero.class(hero, :rogue)
    assert reason == "invalid class and alignment"
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

  ## alignment - invalid alignments
  test "it cannot be an invalid alignment", context do
    {:error, reason} = Hero.alignment(context[:subject], :emo)
    assert reason == "invalid alignment"
  end
  test "it cannot be good if it is a rogue", context do
    {:ok, hero} = Hero.class(context[:subject], :rogue)
    {:error, reason} = Hero.alignment(hero, :good)
    assert reason == "invalid class and alignment"
  end

  ## armor class
  test "it has default armor class of 10", context do
    assert Hero.armor_class(context[:subject]) == 10
  end
  test "it adds dex modifier to armor class", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :dex, 15)
    assert Hero.armor_class(hero) == 12
  end

end
