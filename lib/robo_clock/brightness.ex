defmodule RoboClock.Brightness do
  use GenServer

  alias RoboClock.PubSub

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def initial, do: 1

  def init(:ignored) do
    RoboClock.PubSub.subscribe(:buttons)
    {:ok, initial()}
  end

  defguardp is_b_pressed(event) when event.name == :b and event.action == :pressed

  def handle_info({PubSub.Broadcast, :buttons, event}, brightness)
      when is_b_pressed(event) do
    next_brightness = next(brightness)

    PubSub.publish(:set_brightness, next_brightness)
    {:noreply, next_brightness}
  end

  def handle_info(_event, state), do: {:noreply, state}

  defp next(1), do: 10
  defp next(10), do: 50
  defp next(50), do: 255
  defp next(255), do: 1
end
