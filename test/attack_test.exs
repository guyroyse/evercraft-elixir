defmodule AttackTest do
  use ExUnit.Case

  setup do
    {:ok, attacker: %HeroData{}, defender: %HeroData{} }
  end

  test "it hits when roll beats armor class", context do
    {result, attacker, defender} = Attack.attack(context[:attacker], context[:defender], 15)
    assert result == :hit
  end

  test "it hits when roll meets armor class", context do
    {result, attacker, defender} = Attack.attack(context[:attacker], context[:defender], 10)
    assert result == :hit
  end

  test "it misses when roll is less than armor class", context do
    {result, attacker, defender} = Attack.attack(context[:attacker], context[:defender], 5)
    assert result == :miss
  end

end
