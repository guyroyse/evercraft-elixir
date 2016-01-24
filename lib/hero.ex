defmodule Hero do

  def create() do
    %{
      name: "",
      alignment: :neutral,
      damage: 0,
      str: Ability.create(),
      dex: Ability.create(),
      con: Ability.create(),
      experience: 0
    }
  end

  def name(hero) do
    hero.name
  end

  def name(hero, value) do
    {:ok, %{hero | name: value}}
  end

  def alignment(hero) do
    hero.alignment
  end

  def alignment(hero, value) do
    cond do
      valid_alignment? value -> {:ok, %{hero | alignment: value}}
      true -> {:error, "invalid alignment"}
    end
  end

  def armor_class(hero) do
    10 + Hero.Ability.modifier(hero, :dex)
  end

  def max_hit_points(hero) do
    max(1, 5 + Hero.Ability.modifier(hero, :con)) * level(hero)
  end

  def hit_points(hero) do
    max_hit_points(hero) - hero.damage
  end

  def alive?(hero) do
    hit_points(hero) > 0
  end

  def attack_modifier(hero) do
    div(level(hero), 2) + Hero.Ability.modifier(hero, :str)
  end

  def attack_damage(hero) do
    max(1, base_damage(hero))
  end

  def critical_damage(hero) do
    max(1, 2 * base_damage(hero))
  end

  def experience(hero) do
    hero.experience
  end

  def level(hero) do
    div(hero.experience, 1000) + 1
  end

  def damage(hero, points) do
    {:ok, %{hero | damage: hero.damage + points}}
  end

  def add_experience(hero, points) do
    {:ok, %{hero | experience: hero.experience + points}}
  end

  defp valid_alignment?(value) do
    [:good, :neutral, :evil] |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

  defp base_damage(hero) do
    1 + Hero.Ability.modifier(hero, :str)
  end
end
