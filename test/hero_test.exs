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
  test "it has a default class of no_class", context do
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
  test "it can be a monk", context do
    {:ok, hero} = Hero.class(context[:subject], :monk)
    assert Hero.class(hero) == :monk
  end
  test "it can be a paladin", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    assert Hero.class(hero) == :paladin
  end

  ## class - invalid classes
  test "it cannot be an invalid class", context do
    {:error, reason} = Hero.class(context[:subject], :poser)
    assert reason == "invalid class"
  end
  test "it cannot be a rogue if it is good", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:error, reason} = Hero.class(hero, :rogue)
    assert reason == "invalid class, race, and alignment combo"
  end
  test "it cannot be a paladin if it is neutral", context do
    {:ok, hero} = Hero.alignment(context[:subject], :neutral)
    {:error, reason} = Hero.class(hero, :paladin)
    assert reason == "invalid class, race, and alignment combo"
  end
  test "it cannot be a paladin if it is evil", context do
    {:ok, hero} = Hero.alignment(context[:subject], :evil)
    {:error, reason} = Hero.class(hero, :paladin)
    assert reason == "invalid class, race, and alignment combo"
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
    assert reason == "invalid class, race, and alignment combo"
  end
  test "it cannot be neutral if it is a paladin", context do
    {:ok, hero} = Hero.alignment(context[:subject], :neutral)
    {:error, reason} = Hero.class(hero, :paladin)
    assert reason == "invalid class, race, and alignment combo"
  end
  test "it cannot be evil if it is a paladin", context do
    {:ok, hero} = Hero.alignment(context[:subject], :evil)
    {:error, reason} = Hero.class(hero, :paladin)
    assert reason == "invalid class, race, and alignment combo"
  end
  test "it cannot be evil if it is a halfling", context do
    {:ok, hero} = Hero.race(context[:subject], :halfling)
    {:error, reason} = Hero.alignment(hero, :evil)
    assert reason == "invalid class, race, and alignment combo"
  end

  ## race
  test "it has default race of human", context do
    assert Hero.race(context[:subject]) == :human
  end
  test "it can be human", context do
    {:ok, hero} = Hero.race(context[:subject], :orc)
    {:ok, hero} = Hero.race(hero, :human)
    assert Hero.race(hero) == :human
  end
  test "it can be an orc", context do
    {:ok, hero} = Hero.race(context[:subject], :orc)
    assert Hero.race(hero) == :orc
  end
  test "it can be a dwarf", context do
    {:ok, hero} = Hero.race(context[:subject], :dwarf)
    assert Hero.race(hero) == :dwarf
  end
  test "it can be an elf", context do
    {:ok, hero} = Hero.race(context[:subject], :elf)
    assert Hero.race(hero) == :elf
  end
  test "it can be a halfling", context do
    {:ok, hero} = Hero.race(context[:subject], :halfling)
    assert Hero.race(hero) == :halfling
  end

  ## race - invalid races
  test "it cannot have an invalid race", context do
    {:error, reason} = Hero.race(context[:subject], :romulan)
    assert reason == "invalid race"
  end
  test "it cannot be a halfling if it is evil", context do
    {:ok, hero} = Hero.alignment(context[:subject], :evil)
    {:error, reason} = Hero.race(hero, :halfling)
    assert reason == "invalid class, race, and alignment combo"
  end

end
