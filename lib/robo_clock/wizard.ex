defmodule RoboClock.Wizard do
  @opts [
    ui: [
      title: "RoboClock"
    ]
  ]

  def run_if_unconfigured do
    VintageNetWizard.run_if_unconfigured(@opts)
  end

  def run do
    VintageNetWizard.run_wizard(@opts)
  end
end
