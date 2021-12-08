defmodule RoboClock.Buttons.Mock do
  require Logger
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    handler = Keyword.get(opts, :handler, self())
    {:ok, handler}
  end

  def press(_button) do
    Logger.debug("button press")
  end
end
