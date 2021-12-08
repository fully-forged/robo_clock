defmodule RoboClock.Display do
  @moduledoc false
  use GenServer

  @driver Application.get_env(:robo_clock, :display_driver)

  @height 7
  @separator Matrix.new(@height, 1, 0)

  def driver, do: @driver

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def init(:ignored) do
    RoboClock.PubSub.subscribe(:current_time)
    {:ok, :ignored}
  end

  def handle_info({RoboClock.PubSub.Broadcast, :current_time, current_time}, state) do
    current_time
    |> render()
    |> @driver.draw()

    {:noreply, state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  defp render(datetime) do
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

  defp pad_with_zero([a]), do: [0, a]
  defp pad_with_zero(a), do: a

  defp chars_to_matrix(chars) do
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
