import Config

# Add configuration that is only needed when running on the host here.

config :vintage_net,
  resolvconf: "/dev/null"

config :robo_clock,
  display_driver: RoboClock.Display.Mock,
  buttons_driver: RoboClock.Buttons.Mock
