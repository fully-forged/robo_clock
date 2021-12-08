defmodule RoboClock.Reset do
  use GenServer

  @reset_after System.convert_time_unit(5, :second, :native)
  @buttons_driver Application.get_env(:robo_clock, :buttons_driver)

  def buttons_driver, do: @buttons_driver

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def init(:ignored) do
    {:ok, _pid} = @buttons_driver.start_link(handler: self())
    {:ok, %{status: :released, timestamp: 0}}
  end

  def handle_info(event, state) do
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
