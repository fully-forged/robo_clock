defmodule RoboClock.Reset do
  use GenServer

  alias RoboClock.PubSub

  @reset_after System.convert_time_unit(5, :second, :native)

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def init(:ignored) do
    :ok = PubSub.subscribe(:buttons)
    {:ok, %{status: :released, timestamp: 0}}
  end

  defguardp is_y_released(event) when event.name == :y and event.action == :released
  defguardp is_y_pressed(event) when event.name == :y and event.action == :pressed

  def handle_info({PubSub.Broadcast, :buttons, event}, state)
      when is_y_released(event) and state.status == :released do
    {:noreply, %{state | timestamp: event.timestamp}}
  end

  def handle_info({PubSub.Broadcast, :buttons, event}, state)
      when is_y_pressed(event) and state.status == :released do
    {:noreply, %{state | status: :pressed, timestamp: event.timestamp}}
  end

  def handle_info({PubSub.Broadcast, :buttons, event}, state)
      when is_y_released(event) and state.status == :pressed do
    elapsed = event.timestamp - state.timestamp

    if elapsed >= @reset_after do
      RoboClock.Wizard.run()
    end

    {:noreply, %{state | status: :released, timestamp: event.timestamp}}
  end

  def handle_info(_event, state), do: {:noreply, state}
end
