defmodule AttackTest do
  use ExUnit.Case

  setup do
    {:ok, attacker: %HeroData{}, defender: %HeroData{} }
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

  test "it damages opponent on a hit", context do
    {:hit, _, defender} = Attack.attack(context[:attacker], context[:defender], 15)
    assert Hero.hit_points(defender) == 4
  end

  test "it doubly damages opponent on a critical", context do
    {:critical, _, defender} = Attack.attack(context[:attacker], context[:defender], 20)
    assert Hero.hit_points(defender) == 3
  end

end
