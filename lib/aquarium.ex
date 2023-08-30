defmodule Aquarium do
  @moduledoc """
  Documentation for `Aquarium`.
  This module should be able to generate an Aquarium and also update it
  """
  alias Aquarium.Thing

  defstruct dim: {10, 20}, things: []

  @type t() :: %__MODULE__{
          dim: {integer(), integer()},
          things: list(Aquarium.Thing.t())
        }

  @top_weight 0.3

  @level_weight 0.2
  @level_special_weight 0.19

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
      when is_integer(cols_num) and is_integer(rows_num) and cols_num > 2 and rows_num > 2 do
    things =
      for row <- 0..(rows_num - 1) do
        for col <- 0..(cols_num - 1) do
          if random_weight(@level_weight) do
            Thing.new({row, col}, :fish)
          end
        end
        |> Enum.reject(&is_nil/1)
      end
      |> List.flatten()

    %Aquarium{
      dim: dim,
      things: things
    }
  end

  @doc """
  display(aquarium) - takes and %Aquarium{} as input and returns a string - its display.

  Algorithm: create a big 1-d list representing every cell in the grid (of size rows*cols)
    replace every item place with a thing
      and join everything together.
  """
  @spec display(t()) :: String.t()
  def display(%Aquarium{dim: {rows_num, cols_num}, things: things}) do
    (List.duplicate(@empty, rows_num * cols_num)
     |> replace_empty_with_things(things, cols_num)
     |> Enum.chunk_every(cols_num)
     |> Enum.map(fn row -> row ++ ["\n"] end)
     |> Enum.map(fn row -> Enum.join(row, " ") end)
     |> List.flatten()
     |> Enum.join()) <> "\n"
  end

  defp replace_empty_with_things(list_acc, [], _), do: list_acc

  defp replace_empty_with_things(list_acc, things, cols_num) do
    {%Thing{pos: {row, col}, face: face}, things} = List.pop_at(things, 0)
    i = cols_num * (row + 1) + col - cols_num

    list_acc = List.replace_at(list_acc, i, face)

    replace_empty_with_things(list_acc, things, cols_num)
  end
end
