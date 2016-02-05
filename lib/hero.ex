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
      {:error, "class cannot be #{value}"}
    end
  end

  def race(hero) do
    hero.race
  end

  def race(hero, value) do
    if valid_race?(value) do
      class_race_and_alignment(hero, Hero.class(hero), value, Hero.alignment(hero))
    else
      {:error, "race cannot be #{value}"}
    end
  end

  def alignment(hero) do
    hero.alignment
  end

  def alignment(hero, value) do
    if valid_alignment?(value) do
      class_race_and_alignment(hero, Hero.class(hero), Hero.race(hero), value)
    else
      {:error, "alignment cannot be #{value}"}
    end
  end

  defp class_race_and_alignment(hero, class, race, alignment) do
    case valid_class_race_alignment_combo(class, race, alignment) do
      :ok -> {:ok, %{hero | class: class, race: race, alignment: alignment}}
      error -> {:error, error}
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

  defp valid_class_race_alignment_combo(class, race, alignment) do
    case { valid_class_for_alignment(class, alignment), valid_race_for_alignment(race, alignment) } do
      { :ok, :ok } -> :ok
      { :ok, error } -> error
      { error, :ok } -> error
      _ -> "halfling paladins cannot be evil"
    end
  end

  defp valid_class_for_alignment(class, alignment) do
    case {class, alignment} do
      {:rogue, :good} -> "rogues cannot be good"
      {:paladin, :evil} -> "paladins must be good"
      {:paladin, :neutral} -> "paladins must be good"
      _ -> :ok
    end
  end

  defp valid_race_for_alignment(race, alignment) do
    case {race, alignment} do
      {:halfling, :evil} -> "halflings cannot be evil"
      _ -> :ok
    end
  end

end
