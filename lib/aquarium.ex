defmodule Aquarium do
  @moduledoc """
  Documentation for `Aquarium`.
  This module should be able to generate an Aquarium and also update it
  """
  alias Aquarium.Thing

  defstruct dim: {10, 20}, top: [], things: [], bottom: []

  @type t() :: %__MODULE__{
          dim: {integer(), integer()},
          top: list(Aquarium.Thing.t()),
          things: list(Aquarium.Thing.t()),
          bottom: list(Aquarium.Thing.t())
        }

  defguardp is_valid_dim_num(num) when is_integer(num) and num > 2

  defguard is_valid_dim(dim)
           when is_valid_dim_num(elem(dim, 0)) and is_valid_dim_num(elem(dim, 1))

  @top_weight 0.3

  @fish_weight 0.2
  @fish_special_weight 0.19

  @bubble_weight 0.05

  @bottom_weight 0.8
  @bottom_special_weight 0.12

  @empty "\u3000"

  @spec random_weight(float()) :: boolean()
  defp random_weight(weight) when is_float(weight) do
    rand = :rand.uniform()

    rand < weight
  end

  def new(dim = {rows_num, cols_num})
      when is_valid_dim(dim) do
    top = generate_top(dim)
    things = generate_things({rows_num - 1, cols_num})
    bottom = generate_bottom(dim)

    %Aquarium{
      dim: dim,
      top: top,
      things: things,
      bottom: bottom
    }
  end

  defp generate_top(dim = {_, cols_num}) when is_valid_dim(dim) do
    for col <- 0..(cols_num - 1) do
      if random_weight(@top_weight) do
        Thing.new({0, col}, :top)
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  defp generate_things(dim = {rows_num, cols_num}) when is_valid_dim(dim) do
    # starts at 1 to give 0 to top, - 2 because - 1 for index + - 1 for bottom - EDIT: need not - 2 what? why? i don't understand but it works like this
    for row <- 1..(rows_num - 1) do
      for col <- 0..(cols_num - 1) do
        if random_weight(@fish_weight) do
          pos = {row, col}

          if random_weight(@fish_special_weight) do
            Thing.new(pos, :special_fish)
          else
            Thing.new(pos, :fish)
          end
        end
      end
      |> Enum.reject(&is_nil/1)
    end
    |> List.flatten()
  end

  @spec generate_things({integer(), integer()}) :: [Thing.t()]
  defp generate_bottom(dim = {rows_num, cols_num}) when is_valid_dim(dim) do
    for col <- 0..(cols_num - 1) do
      if random_weight(@bottom_weight) do
        pos = {rows_num - 1, col}

        if random_weight(@bottom_special_weight) do
          Thing.new(pos, :special_bottom)
        else
          Thing.new(pos, :bottom)
        end
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  display(aquarium) - takes and %Aquarium{} as input and returns a string - its display.

  Algorithm: create a big 1-d list representing every cell in the grid (of size rows*cols)
    replace every item place with a thing
      and join everything together.
  """
  @spec display(t()) :: String.t()
  def display(%Aquarium{dim: {rows_num, cols_num}, top: top, things: things, bottom: bottom}) do
    List.duplicate(@empty, rows_num * cols_num)
    |> replace_empty_with_things(top ++ things ++ bottom, cols_num)
    |> Enum.chunk_every(cols_num)
    |> Enum.map(fn row -> row ++ ["\n"] end)
    |> Enum.map(fn row -> Enum.join(row, " ") end)
    |> List.flatten()
    |> Enum.join()
  end

  defp replace_empty_with_things(list_acc, [], _), do: list_acc

  defp replace_empty_with_things(list_acc, things, cols_num) do
    {%Thing{pos: {row, col}, face: face}, things} = List.pop_at(things, 0)
    i = cols_num * (row + 1) + col - cols_num

    list_acc = List.replace_at(list_acc, i, face)

    replace_empty_with_things(list_acc, things, cols_num)
  end
end
