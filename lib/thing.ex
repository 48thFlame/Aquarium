defmodule Aquarium.Thing do
  defstruct pos: {0, 0}, face: ""

  @type t() :: %__MODULE__{
          face: String.t(),
          pos: {integer(), integer()}
        }

  @fish ["🐠", "🐟", "🐡"]
  @special_fish ["🐙", "🐬", "🐋", "🦈", "🦑", "🦐", "🪼"]

  @bottom ["🪸", "🌿", "🌱", "🌾"]
  @special_bottom ["🦀", "🦞", "🐚", "🏰", "🪨", "🐌", "💰", "💎", "☘️", "⚓", "🔱", "🗿"]

  # maybe also? "🐳", "🛟", "🧜🏻‍♀️"
  @top ["🌊", "⛵", "🏊", "🏄", "🚣", "🚤", "🚢", "⛴️"]

  @bubble "🫧"
  # 🟦
  # @empty "\u3000"

  defguard is_valid_pos(pos) when is_integer(elem(pos, 0)) and is_integer(elem(pos, 1))

  @spec new(tuple, :bottom | :bubble | :fish | :special_bottom | :special_fish | :top | binary) ::
          Aquarium.Thing.t()
  @doc """
    new() creates a new thing
  """
  def new(pos, :fish) when is_valid_pos(pos) do
    new(pos, Enum.random(@fish))
  end

  def new(pos, :special_fish) when is_valid_pos(pos) do
    new(pos, Enum.random(@special_fish))
  end

  def new(pos, :bottom) when is_valid_pos(pos) do
    new(pos, Enum.random(@bottom))
  end

  def new(pos, :special_bottom) when is_valid_pos(pos) do
    new(pos, Enum.random(@special_bottom))
  end

  def new(pos, :top) when is_valid_pos(pos) do
    new(pos, Enum.random(@top))
  end

  def new(pos, :bubble) when is_valid_pos(pos) do
    new(pos, @bubble)
  end

  def new(pos, face) when is_valid_pos(pos) and is_binary(face) do
    %__MODULE__{
      face: face,
      pos: pos
    }
  end
end
