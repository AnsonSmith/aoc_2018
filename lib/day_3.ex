defmodule Aoc2018.Day3 do
  def part_1() do
      get_input()
      |> Stream.map(fn line -> line |> parse_line() end)
      |> Stream.map(fn dimensions -> build_coords(dimensions) end)
      |> Stream.flat_map(fn x -> x end)
      |> get_overlapping_coords()
      |> Enum.count()
  end

  def part_2() do
    coordinates_with_ids =
      get_input()
      |> Stream.map(fn line -> line |> parse_line() end)
      |> Stream.map(fn dimensions -> {Map.get(dimensions, "claim_id"), build_coords(dimensions)} end)

    overlapping_coords =
      coordinates_with_ids
      |> Stream.flat_map( fn({_id, coords}) -> coords end)
      |> get_overlapping_coords()

    #Enum.filter(coordinates_with_ids, fn({_id, coords}) ->
    #  Enum.any?(coords, fn(coord) ->  Enum.member?(overlapping_coords, coord) end)
    #end)
    Enum.find_value(coordinates_with_ids, fn {id, plots} ->
      if Enum.any?(plots, &Enum.member?(overlapping_coords, &1)), do: false, else: id
    end)

  end

  defp get_overlapping_coords(all_coords) do
    all_coords
    |> Enum.reduce(%{}, fn x, acc ->
      acc = Map.update(acc, x, 1, &(&1 + 1))
      acc
    end)
    |> Enum.filter(fn {_coord, cnt} -> cnt > 1 end)
    |> Enum.map(fn({coord, _cnt})-> coord end)
  end

  defp parse_line(line) do
    regex =
      ~r/#(?<claim_id>\d+).@.(?<from_left>\d+),(?<from_top>\d+):.(?<box_width>\d+)x(?<box_height>\d+)/

    Regex.named_captures(regex, line)
  end

  defp build_coords(%{
         "from_left" => start_x_str,
         "from_top" => start_y_str,
         "box_width" => box_width_str,
         "box_height" => box_height_str
       }) do
    from_left = String.to_integer(start_x_str)
    from_top = String.to_integer(start_y_str)
    box_width = String.to_integer(box_width_str)
    box_height = String.to_integer(box_height_str)

    # thanks to Chris Keathley for the list comprehension, I had a bug in my original implementation
    for x <- from_left..(from_left + box_width - 1),
        y <- from_top..(from_top + box_height - 1) do
      {x, y}
    end
  end

  defp get_input() do
    File.stream!("priv/day_3_input.dat")
    |> Stream.map(&String.trim/1)
  end
end
