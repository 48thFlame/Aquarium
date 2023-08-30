defmodule Main do
  def clear_screen do
    IO.write([IO.ANSI.home(), IO.ANSI.clear()])
  end

  def term_dimensions do
    {:ok, rows_num} = :io.rows()
    {:ok, cols_num} = :io.columns()
    {rows_num, cols_num}
  end

  def main do
    rows_num = 6
    cols_num = 8

    aquarium =
      Aquarium.new({rows_num, cols_num}) |> Aquarium.display() |> IO.puts()
  end
end

Main.main()
