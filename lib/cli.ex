defmodule Aquarium.Cli do
  def clear_screen do
    IO.write([IO.ANSI.home(), IO.ANSI.clear()])
  end

  def term_dimensions do
    {:ok, rows_num} = :io.rows()
    {:ok, cols_num} = :io.columns()
    {rows_num - 2, div(cols_num, 3)}
  end

  def main_loop(aquarium) do
    clear_screen()

    Aquarium.display(aquarium) |> IO.puts()
    Process.sleep(100)

    main_loop(Aquarium.update(aquarium))
  end

  def main(args \\ []) do
    args_len = length(args)

    case args_len do
      0 ->
        rows_num = 8
        cols_num = 12

        Aquarium.new({rows_num, cols_num}) |> Aquarium.display() |> IO.puts()

      1 ->
        aquarium =
          Aquarium.new(term_dimensions())

        main_loop(aquarium)

      2 ->
        cols_num = hd(args) |> Integer.parse()
        rows_num = tl(args) |> List.first() |> Integer.parse()

        unless cols_num == :error or rows_num == :error do
          cols_num = elem(cols_num, 0)
          rows_num = elem(rows_num, 0)

          unless cols_num < 4 or rows_num < 4 do
            Aquarium.new({rows_num, cols_num}) |> Aquarium.display() |> IO.puts()
          else
            exit("Invalid argument/s")
          end
        else
          exit("Invalid argument/s")
        end
    end
  end
end
