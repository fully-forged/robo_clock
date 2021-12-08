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
    SystemRegistry.register(min_interval: 1000)
    {:ok, :ignored}
  end

  def handle_info({:system_registry, :global, %{state: state}}, s) do
    state.current_time
    |> DateTime.from_unix!()
    |> render()
    |> @driver.draw()

    {:noreply, s}
  end

  def handle_info(_, s) do
    {:noreply, s}
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
