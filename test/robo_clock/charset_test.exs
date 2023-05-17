defmodule RoboClock.CharsetTest do
  use ExUnit.Case, async: true

  alias RoboClock.Charset

  test "explicit implementation matches sigil implementation" do
    for i <- 0..9 do
      assert Charset.char(i) == Charset.new_char(i)
    end

    assert Charset.char(:colon) == Charset.new_char(:colon)
    assert Charset.char(:column) == Charset.new_char(:column)
  end
end
