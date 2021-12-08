defmodule RoboClock.Buttons do
  use GenServer

  @buttons_driver Application.get_env(:robo_clock, :buttons_driver)

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def init(:ignored) do
    {:ok, _pid} = @buttons_driver.start_link(handler: self())
    {:ok, %{status: :released, timestamp: 0}}
  end

  def handle_info(event, state) do
    RoboClock.PubSub.publish(:buttons, event)
    {:noreply, state}
  end
end
