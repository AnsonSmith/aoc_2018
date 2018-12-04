defmodule Aoc2018.Day2 do
  def part_1() do
    {twos, threes} =
      get_input()
      |> Enum.map(fn itm ->
        itm
        |> String.graphemes()
        |> Enum.reduce(%{}, fn char, acc -> Map.put(acc, char, (acc[char] || 0) + 1) end)
      end)
      |> Enum.reduce({0, 0}, fn itm, {curr_twos, curr_threes} ->
        contains_twos = Enum.any?(itm, fn {_ch, num} -> num == 2 end)
        contains_threes = Enum.any?(itm, fn {_ch, num} -> num == 3 end)
        {update_twos(curr_twos, contains_twos), update_threes(curr_threes, contains_threes)}
      end)

    twos * threes
  end

  def part_2() do
    input = get_input()

    input
    |> Enum.reduce(MapSet.new(), fn x, acc2 ->
      max_common =
        input
        |> Enum.reduce([], fn y, acc -> build_diff(x, y, acc) end)
        |> Enum.max_by(&String.length/1)

      include_diff(String.length(x) - String.length(max_common), max_common, acc2)
    end)
    |> MapSet.to_list()
  end

  defp build_diff(string1, string1, acc) do
    acc
  end

  defp build_diff(string1, string2, acc) do
    commonchars =
      string1
      |> String.myers_difference(string2)
      |> Keyword.get_values(:eq)
      |> Enum.join()

    acc ++ [commonchars]
  end

  defp include_diff(1, maxcommon, acc) do
    MapSet.put(acc, maxcommon)
  end

  defp include_diff(_numdiff, _maxcommon, acc) do
    acc
  end

  defp update_twos(current_count, true) do
    current_count + 1
  end

  defp update_twos(current_count, false) do
    current_count
  end

  defp update_threes(current_count, true) do
    current_count + 1
  end

  defp update_threes(current_count, false) do
    current_count
  end

  defp get_input() do
    File.stream!("priv/day_2_input.dat")
    |> Stream.map(&String.trim/1)
  end
end
