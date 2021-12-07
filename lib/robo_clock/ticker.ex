defmodule RoboClock.Ticker do
  @moduledoc false
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ignored, name: __MODULE__)
  end

  def init(:ignored) do
    Process.send_after(self(), :tick, 1000)
    {:ok, :ignored}
  end

  def handle_info(:tick, state) do
    {elapsed, _} =
      :timer.tc(fn ->
        now =
          DateTime.utc_now()
          |> DateTime.to_unix()

        SystemRegistry.update([:state, :current_time], now)
      end)

    Process.send_after(self(), :tick, 1000 - div(elapsed, 1000))
    {:noreply, state}
  end
end
