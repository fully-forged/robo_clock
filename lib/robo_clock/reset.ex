defmodule RoboClock.Reset do
  use GenServer
  require Logger

  @reset_after System.convert_time_unit(5, :second, :native)

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def init(:ignored) do
    :ok = RoboClock.PubSub.subscribe(:buttons)
    {:ok, %{status: :released, timestamp: 0}}
  end

  def handle_info({RoboClock.PubSub.Broadcast, :buttons, event}, state) do
    case event.name do
      :y -> handle_reset(event, state)
      _other -> {:noreply, state}
    end
  end

  defp handle_reset(%{action: :released, timestamp: timestamp}, %{status: :released} = s) do
    {:noreply, %{s | timestamp: timestamp}}
  end

  defp handle_reset(%{action: :pressed, timestamp: timestamp}, %{status: :released} = s) do
    {:noreply, %{s | status: :pressed, timestamp: timestamp}}
  end

  defp handle_reset(%{action: :released, timestamp: timestamp}, %{status: :pressed} = s) do
    elapsed = timestamp - s.timestamp

    if elapsed >= @reset_after do
      RoboClock.Wizard.run()
    end

    {:noreply, %{s | status: :released, timestamp: timestamp}}
  end
end
