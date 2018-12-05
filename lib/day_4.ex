defmodule Aoc2018.Day4 do
  def part_1() do
    {_curr_action,  guards} =
      get_input()
      |> Enum.map(&parse_action/1)
      |> Enum.reduce({%{}, %{}}, fn(%{"action" => action, "minutes" => minute }, {curr_action, results}) ->
         handle_action(action, minute, curr_action, results)
      end)

      {sleepy_guard_id, {_total_sleep_time, mins_asleep}} = guards
      |> Enum.max_by(fn({_guard_id, {total_slept, _mins_slept}} ) -> total_slept end)

      {most_mins_slept, _times_asleep} = mins_asleep
      |> Enum.max_by(fn({_key, val}) -> val end)

      String.to_integer(sleepy_guard_id) * most_mins_slept
  end

  def part_2() do
    {_curr_action,  guards} =
      get_input()
      |> Enum.map(&parse_action/1)
      |> Enum.reduce({%{}, %{}}, fn(%{"action" => action, "minutes" => minute }, {curr_action, results}) ->
         handle_action(action, minute, curr_action, results)
      end)

      {guard_id, {minute, _times_asleep}} = guards
      |> Enum.map(fn({guard_id, {_total_mins, each_min}})->
      {guard_id, Enum.max_by(each_min, fn({_min, times})-> times end)}
      end)
      |> Enum.max_by(fn({_id, {_min, times}}) -> times end)
      String.to_integer(guard_id) * minute
  end

  defp parse_action(line) do
    regex = ~r/\[\d+-\d+-\d+.\d+:(?<minutes>\d+)\].(?<action>.+)/
    Regex.named_captures(regex,line)
  end



  defp handle_action("f" <> _rest = _action, min, %{"guard_id" => _guard_id} = curr_action, results) do
    { Map.put(curr_action, :start_sleep, String.to_integer(min)) , results}
  end

  defp handle_action("w" <> _rest = _action, min, %{"guard_id" => guard_id, start_sleep: start_sleep} = _curr_action, results) do
    sleep_time = String.to_integer(min) - start_sleep
    minutes_slept = start_sleep..String.to_integer(min)-1
    initial_mins = Enum.reduce(minutes_slept, %{}, fn(x, acc) ->
      Map.put(acc, x, 1)
     end)
    {%{"guard_id" => guard_id} , Map.update(results, guard_id, {sleep_time, initial_mins}, fn({total_sleep_time, curr_slept_mins})->
      new_slept_time = total_sleep_time + sleep_time
      new_mins_slept = Enum.reduce(minutes_slept, curr_slept_mins, fn(min, acc) ->
        Map.update(acc, min, 1, fn(m) ->
          m + 1
        end)
      end)
      {new_slept_time, new_mins_slept} end)}
  end
  defp handle_action("G" <> _rest = action, _min, _curr_action, results) do
    regex = ~r/Guard.#(?<guard_id>\d+).+/
    {Regex.named_captures(regex, action), results}
  end


  defp get_input() do
    File.stream!("priv/day_4_input.dat")
    |> Stream.map(&String.trim/1)
    |> Enum.sort()
  end
end
