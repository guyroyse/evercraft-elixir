defmodule Hero do

  def create() do
    %{
      name: "",
      alignment: :neutral,
      damage: 0,
      str: Ability.create(),
      dex: Ability.create(),
      con: Ability.create(),
      int: Ability.create(),
      wis: Ability.create(),
      cha: Ability.create(),
      experience: 0,
      class: :no_class,
      race: :human
    }
  end

  def name(hero) do
    hero.name
  end

  def name(hero, value) do
    {:ok, %{hero | name: value}}
  end

  def class(hero) do
    hero.class
  end

  def class(hero, value) do
    if valid_class?(value) do
      class_race_and_alignment(hero, value, Hero.race(hero), Hero.alignment(hero))
    else
      {:error, "invalid class"}
    end
  end

  def race(hero) do
    hero.race
  end

  def race(hero, value) do
    if valid_race?(value) do
      class_race_and_alignment(hero, Hero.class(hero), value, Hero.alignment(hero))
    else
      {:error, "invalid race"}
    end
  end

  def alignment(hero) do
    hero.alignment
  end

  def alignment(hero, value) do
    if valid_alignment?(value) do
      class_race_and_alignment(hero, Hero.class(hero), Hero.race(hero), value)
    else
      {:error, "invalid alignment"}
    end
  end

  defp class_race_and_alignment(hero, class, race, alignment) do
    if valid_class_race_alignment_combo?(class, race, alignment) do
      {:ok, %{hero | class: class, race: race, alignment: alignment}}
    else
      {:error, "invalid class, race, and alignment combo"}
    end
  end

  defp valid_alignment?(value) do
    value_in_list([:good, :neutral, :evil], value)
  end

  defp valid_class?(value) do
    value_in_list([:no_class, :fighter, :rogue, :monk, :paladin], value)
  end

  defp valid_race?(value) do
    value_in_list([:human, :orc, :dwarf, :elf, :halfling], value)
  end

  defp value_in_list(list, value) do
    list |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

  defp valid_class_race_alignment_combo?(class, race, alignment) do
    valid_class_for_alignment(class, alignment) && valid_race_for_alignment(race, alignment)
  end

  defp valid_class_for_alignment(class, alignment) do
    case {class, alignment} do
      {:rogue, :good} -> false
      {:paladin, :evil} -> false
      {:paladin, :neutral} -> false
      {_, _} -> true
    end
  end

  defp valid_race_for_alignment(race, alignment) do
    case {race, alignment} do
      {:halfling, :evil} -> false
      {_, _} -> true
    end
  end

end
