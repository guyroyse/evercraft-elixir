defmodule HeroTest do
  use ExUnit.Case

  setup do
    {:ok, subject: %HeroData{} }
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

  ## hit points

  test "it has default hit points of 5", context do
    assert Hero.hit_points(context[:subject]) == 5
  end

end
