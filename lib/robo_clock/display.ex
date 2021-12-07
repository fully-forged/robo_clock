defmodule RoboClock.Display do
  @moduledoc false
  @height 7
  @separator Matrix.new(@height, 1, 0)

  def render(datetime) do
    datetime
    |> extract_digits
    |> chars_to_matrix()
  end

  defp extract_digits(time) do
    hour = Integer.digits(time.hour)
    minute = Integer.digits(time.minute)
    minute = pad_with_zero(minute)
    hour = pad_with_zero(hour)
    hour ++ minute
  end

  def pad_with_zero([a]), do: [0, a]
  def pad_with_zero(a), do: a

  def pad_with_space([a]), do: [:space, a]
  def pad_with_space(a), do: a

  def chars_to_matrix(chars) do
    center =
      chars
      |> Enum.map(&RoboClock.Charset.char/1)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.intersperse(@separator)

    # I apologize for this - it's the result of trial and error
    # and ultimately I should know better
    [@separator | center]
    |> Enum.reverse()
    |> join(@separator)
    |> Enum.reverse()
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
  end

  defp join([], joined), do: joined

  defp join([current | rest], joined) do
    join(rest, :lists.zipwith(fn a, b -> a ++ b end, current, joined))
  end
end
