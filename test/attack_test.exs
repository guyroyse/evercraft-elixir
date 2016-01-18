defmodule AttackTest do
  use ExUnit.Case

  setup do
    {:ok, attacker: Hero.create(), defender: Hero.create() }
  end

  test "it misses when roll is less than armor class", context do
    {result, _, _} = Attack.attack(context[:attacker], context[:defender], 5)
    assert result == :miss
  end

  test "it hits when roll meets armor class", context do
    {result, _, _} = Attack.attack(context[:attacker], context[:defender], 10)
    assert result == :hit
  end

  test "it hits when roll beats armor class", context do
    {result, _, _} = Attack.attack(context[:attacker], context[:defender], 15)
    assert result == :hit
  end

  test "it crits when roll is natural 20", context do
    {result, _, _} = Attack.attack(context[:attacker], context[:defender], 20)
    assert result == :critical
  end

  test "it does not damage oppoent on a miss", context do
    {:miss, _, defender} = Attack.attack(context[:attacker], context[:defender], 5)
    assert Hero.hit_points(defender) == 5
  end

  test "it applies attack damage to opponent on a hit", context do
    {:ok, attacker} = Hero.ability_score(context[:attacker], :str, 12)  ## attack damage = 2
    {:hit, attacker, defender} = Attack.attack(attacker, context[:defender], 15)
    assert Hero.hit_points(defender) == 5 - Hero.attack_damage(attacker)
  end

  test "it applies critical damage to opponent on a critical", context do
    {:ok, attacker} = Hero.ability_score(context[:attacker], :str, 12)  ## crit damage = 4
    {:critical, attacker, defender} = Attack.attack(attacker, context[:defender], 20)
    assert Hero.hit_points(defender) == 5 - Hero.critical_damage(attacker)
  end

  test "it adds attack modifer to attack roll", context do
    {:ok, attacker} = Hero.ability_score(context[:attacker], :str, 20)  ## attack modifier = +5
    {result, _, _} = Attack.attack(attacker, context[:defender], 5)
    assert result == :hit
  end

  test "it considers opponent armor class when determing a hit", context do
    {:ok, defender} = Hero.ability_score(context[:defender], :dex, 20)  ## armor class = 15
    {result, _, _} = Attack.attack(context[:attacker], defender, 10)
    assert result == :miss
  end

  test "it does not add experience on a miss", context do
    {:miss, attacker, _} = Attack.attack(context[:attacker], context[:defender], 5)
    assert Hero.experience(attacker) == 0
  end

  test "it adds experience on a hit", context do
    {:hit, attacker, _} = Attack.attack(context[:attacker], context[:defender], 15)
    assert Hero.experience(attacker) == 10
  end

  test "it adds experience on a critical", context do
    {:critical, attacker, _} = Attack.attack(context[:attacker], context[:defender], 20)
    assert Hero.experience(attacker) == 10
  end

end
