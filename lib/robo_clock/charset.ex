defmodule RoboClock.Charset do
  @moduledoc """
  The charset is implemented via a Matrix.

  Each character is 7 pixels tall, and implemented as a matrix of 7 elements,
  with all elements being lists of the same size.

  A custom sigil (`~h`) is available to write characters in a pixel grid.

  To write a character, one should only use `1` for pixel on, and `0` for pixel off.
  """

  import RoboClock.Charset.Sigils

  @num_lines 7

  ################################################################################
  #################################### SPACE #####################################
  ################################################################################

  def char(?\s), do: char(:space)

  def char(:space), do: repeat([0, 0, 0], @num_lines)

  ################################################################################
  ################################### NUMBERS ####################################
  ################################################################################

  def char(1), do: ~h(
  000
  010
  110
  010
  010
  111
  000
  )

  def char(2), do: ~h(
  000
  111
  001
  111
  100
  111
  000
  )

  def char(3), do: ~h(
  000
  111
  001
  111
  001
  111
  000
  )

  def char(4), do: ~h(
  000
  101
  101
  111
  001
  001
  000
  )

  def char(5), do: ~h(
  000
  111
  100
  111
  001
  111
  000
  )

  def char(6), do: ~h(
  000
  111
  100
  111
  101
  111
  000
  )

  def char(7), do: ~h(
  000
  111
  001
  001
  001
  001
  000
  )

  def char(8), do: ~h(
  000
  111
  101
  111
  101
  111
  000
  )

  def char(9), do: ~h(
  000
  111
  101
  111
  001
  001
  000
  )

  def char(0), do: ~h(
  000
  111
  101
  101
  101
  111
  000
  )

  ################################################################################
  ############################## SPECIAL CHARACTERS ##############################
  ################################################################################

  def char(:colon), do: ~h(
  0
  0
  1
  0
  1
  0
  0
  )

  def char(:column), do: ~h(
  0
  0
  0
  0
  0
  0
  0
  )

  def char(:zero_width_column), do: repeat([], @num_lines)

  ################################################################################
  ################################## HELPERS #####################################
  ################################################################################

  defp repeat(char, times) do
    Enum.map(1..times, fn _ -> char end)
  end
end
