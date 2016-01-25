defmodule Hero do

  def create() do
    %{
      name: "",
      alignment: :neutral,
      damage: 0,
      str: Ability.create(),
      dex: Ability.create(),
      con: Ability.create(),
      experience: 0,
      class: :no_class
    }
  end

  def name(hero) do
    hero.name
  end

  def name(hero, value) do
    {:ok, %{hero | name: value}}
  end

  def experience(hero) do
    hero.experience
  end

  def level(hero) do
    div(hero.experience, 1000) + 1
  end

  def class(hero) do
    hero.class
  end

  def class(hero, value) do
    cond do
      valid_class? value -> {:ok, %{hero | class: value}}
      true -> {:error, "invalid class"}
    end
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

  def add_experience(hero, points) do
    {:ok, %{hero | experience: hero.experience + points}}
  end

  defp valid_alignment?(value) do
    [:good, :neutral, :evil] |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

  defp valid_class?(value) do
    [:no_class, :fighter] |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

end
