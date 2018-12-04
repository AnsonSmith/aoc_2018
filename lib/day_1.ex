defmodule Aoc2018.Day1 do
  def part_1() do
      get_input()
      |> Stream.map(&String.to_integer/1)
      |> Enum.sum()
  end

  def part_2() do
    get_input()
    |> Stream.map(&String.to_integer/1)
    |> Stream.cycle()
    |> Enum.reduce_while({MapSet.new(), 0}, fn(x, {previous_freqs, curr_freq}) ->
      new_freq = curr_freq + x
      if MapSet.member?(previous_freqs, new_freq) do
        {:halt, new_freq}
      else
        {:cont, {MapSet.put(previous_freqs, new_freq), new_freq}}
      end
    end)
  end

  defp get_input() do
    File.stream!("priv/day_1_input.dat")
    |> Stream.map(&String.trim/1)
  end
end
