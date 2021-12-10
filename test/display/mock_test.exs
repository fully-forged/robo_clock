defmodule RoboClock.Display.MockTest do
  use ExUnit.Case, async: true

  describe "correctly formats a screen canvas" do
    test "shows a separator for even seconds" do
      t = 1_639_129_008 |> DateTime.from_unix!()
      m = RoboClock.Display.render(t, 10)

      expected = """
      ___________________
      |                 |
      |XXX XXX   XXX XXX|
      |X X X X X   X X  |
      |X X XXX   XXX XXX|
      |X X   X X   X X X|
      |XXX   X   XXX XXX|
      |                 |
      ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
      """

      assert expected == RoboClock.Display.Mock.pretty_format(m)
    end

    test "shows a separator for odd seconds" do
      t = 1_639_129_009 |> DateTime.from_unix!()
      m = RoboClock.Display.render(t, 10)

      expected = """
      ___________________
      |                 |
      |XXX XXX   XXX XXX|
      |X X X X     X X  |
      |X X XXX   XXX XXX|
      |X X   X     X X X|
      |XXX   X   XXX XXX|
      |                 |
      ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
      """

      assert expected == RoboClock.Display.Mock.pretty_format(m)
    end
  end
end
