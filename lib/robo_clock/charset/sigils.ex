defmodule RoboClock.Charset.Sigils do
  @moduledoc false

  def sigil_h(s, _opts) do
    s
    |> String.split()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn gs -> Enum.map(gs, &String.to_integer/1) end)
  end
end
