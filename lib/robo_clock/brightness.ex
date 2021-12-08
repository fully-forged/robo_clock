defmodule RoboClock.Brightness do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def initial, do: 1

  def init(:ignored) do
    RoboClock.PubSub.subscribe(:buttons)
    {:ok, initial()}
  end

  def handle_info({RoboClock.PubSub.Broadcast, :buttons, event}, state) do
    case event.name do
      :b -> handle_brightness(event, state)
      _other -> {:noreply, state}
    end
  end

  defp handle_brightness(%{action: :pressed}, brightness) do
    next_brightness = next(brightness)

    RoboClock.PubSub.publish(:set_brightness, next_brightness)
    {:noreply, next_brightness}
  end

  defp handle_brightness(_event, state), do: {:noreply, state}

  defp next(1), do: 10
  defp next(10), do: 50
  defp next(50), do: 255
  defp next(255), do: 1
end
