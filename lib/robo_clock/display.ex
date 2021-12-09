defmodule RoboClock.Display do
  @moduledoc false
  use GenServer

  import Integer

  @driver Application.get_env(:robo_clock, :display_driver)
  @separator RoboClock.Charset.char(:column)
  @zero_width_column RoboClock.Charset.char(:zero_width_column)

  def driver, do: @driver

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def init(:ignored) do
    RoboClock.PubSub.subscribe(:current_time)
    RoboClock.PubSub.subscribe(:set_brightness)
    {:ok, %{brightness: RoboClock.Brightness.initial()}}
  end

  def handle_info({RoboClock.PubSub.Broadcast, :current_time, current_time}, state) do
    current_time
    |> render(state.brightness)
    |> @driver.draw()

    {:noreply, state}
  end

  def handle_info({RoboClock.PubSub.Broadcast, :set_brightness, brightness}, state) do
    @driver.set_brightness(brightness)

    {:noreply, %{state | brightness: brightness}}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  defp render(datetime, brightness) do
    datetime
    |> extract_digits
    |> chars_to_matrix()
    |> adjust_brightness(brightness)
  end

  defp extract_digits(time) do
    hour = Integer.digits(time.hour)
    minute = Integer.digits(time.minute)
    minute = pad_with_zero(minute)
    hour = pad_with_zero(hour)
    hour ++ [sep(time.second)] ++ minute
  end

  defp sep(second) when is_even(second), do: :colon
  defp sep(_second), do: :column

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
    center
    |> Enum.reverse()
    |> join(@zero_width_column)
    |> Enum.reverse()
    |> Enum.map(&Enum.reverse/1)
    |> Enum.reverse()
  end

  defp join([], joined), do: joined

  defp join([current | rest], joined) do
    join(rest, :lists.zipwith(fn a, b -> a ++ b end, current, joined))
  end

  defp adjust_brightness(matrix, brightness) do
    Matrix.scale(matrix, brightness)
  end
end
