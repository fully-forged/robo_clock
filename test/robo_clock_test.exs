defmodule RoboClockTest do
  use ExUnit.Case
  doctest RoboClock

  test "greets the world" do
    assert RoboClock.hello() == :world
  end
end
