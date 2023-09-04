defmodule Main do
  def clear_screen do
    IO.write([IO.ANSI.home(), IO.ANSI.clear()])
  end

  def term_dimensions do
    {:ok, rows_num} = :io.rows()
    {:ok, cols_num} = :io.columns()
    {rows_num - 2, div(cols_num, 3)}
  end

  def main_loop(nil), do: :ok

  def main_loop(aquarium, count) do
    clear_screen()

    Aquarium.display(aquarium) |> IO.puts()
    Process.sleep(250)

    if count <= 0 do
      main_loop(nil)
    else
      main_loop(Aquarium.update(aquarium), count - 1)
    end
  end

  def main do
    rows_num = 8
    cols_num = 12

    aquarium =
      Aquarium.new({rows_num, cols_num})

    main_loop(aquarium, cols_num)
  end
end

Main.main()
