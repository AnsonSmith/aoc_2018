defmodule Aoc2018.Day5 do
  def part_1() do
      get_input()
      |> Enum.into("")
      |> String.graphemes()
      |> List.foldr([], fn(char, acc) -> process_curr_char(char, acc) end)
      |> Enum.count()
  end

  def part_2() do
    original_string = get_input()
    |> Enum.into("")

    ?a..?z
    |> Enum.map(fn(char) -> [List.to_string([char]),String.upcase(List.to_string([char]))] end)
    |> Enum.map(fn(chars) -> String.replace(original_string, chars, "") end)
    |> Enum.map(fn(new_string) ->
      new_string
      |> String.graphemes()
      |> List.foldr([], fn(char, acc) -> process_curr_char(char, acc) end)
      |> Enum.count()
    end)
    |> Enum.min()
  end

  defp process_curr_char(char, []) do
    [char]
  end
  defp process_curr_char(char, [x|rest] = acc) do
    if (characters_collide?(char, x)) do
      rest
     else
       [char|acc]
    end
  end

  defp characters_collide?(<<curr_char_val::utf8>> = _curr_char, <<char_to_check_val::utf8>> = _char_to_check ) do
    abs(curr_char_val - char_to_check_val) == 32
  end


  defp get_input() do
    File.stream!("priv/day_5_input.dat")
    |> Stream.map(&String.trim/1)
  end
end
