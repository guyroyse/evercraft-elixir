defmodule Hero do

  def create() do
    %{
      name: "",
      alignment: :neutral,
      hit_points: 5,
      str: Ability.create(),
      dex: Ability.create(),
      con: Ability.create()
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

  def ability_score(hero, ability) do
    Ability.score(hero[ability])
  end

  def ability_score(hero, ability, value) do
    case Ability.score(hero[ability], value) do
      {:ok, new_ability} -> {:ok, %{ hero | ability => new_ability } }
      {status, result} -> {status, result}
    end

  end

  def ability_modifier(hero, ability) do
    Ability.modifier(hero[ability])
  end

  def armor_class(_) do
    10
  end

  def hit_points(hero) do
    hero.hit_points
  end

  def alive?(hero) do
    hit_points(hero) > 0
  end

  def damage(hero, points) do
    {:ok, %{hero | hit_points: hero.hit_points - points}}
  end

  defp valid_alignment?(value) do
    [:good, :neutral, :evil] |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

end
