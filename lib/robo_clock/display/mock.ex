defmodule RoboClock.Display.Mock do
  require Logger

  def draw(canvas) do
    Logger.debug(fn ->
      """
      Dummy Display -> content:

      #{pretty_format(canvas)}
      """
    end)
  end

  def set_brightness(brightness) do
    Logger.debug(fn ->
      "Dummy Display -> set brightness to #{brightness}"
    end)
  end

  defp pretty_format(m) do
    m
    |> Enum.reverse()
    |> Enum.map(fn r -> show_row(r) <> "\n" end)
    |> add_horizontal_borders()
    |> Enum.join("")
  end

  defp show_row(r) do
    str =
      r
      |> Enum.map(fn
        1 -> "X"
        0 -> " "
      end)
      |> Enum.join("")

    "|" <> str <> "|"
  end

  defp add_horizontal_borders([first_line | _other] = lines) do
    width = String.length(first_line) - 1

    [String.duplicate("_", width) <> "\n"] ++ lines ++ [String.duplicate("‾", width) <> "\n"]
  end
end
