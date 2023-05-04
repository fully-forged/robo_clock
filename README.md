# RoboClock

RoboClock is a firmware for the [Pimoroni Scroll Bot](https://shop.pimoroni.com/products/scroll-bot-pi-zero-w-project-kit?variant=38476730378&gclid=Cj0KCQjwr82iBhCuARIsAO0EAZznNj-lffNXKPynnAZUE9o8-09JADqg8rVW_qU8wyGrcMQSPVyIdR8aAt8jEALw_wcB).

## Setup

Requires [Nix with Flake Support](https://nixos.wiki/wiki/Flakes) and a working [direnv](https://direnv.net) installation.

Upon cloning and running `direnv allow`, Nix should kick in and install dependencies, leaving an environment ready for development.

## Development

All common tasks are covered in the included Makefile.

## Installing/updating the firmware

To flash a MicroSD card, use `make firmware.burn`. For over-the-air updates to a local device, you can then use `make firmware.upload`.

## Usage

On first boot, the device will broadcast a `ROBOCLOCK` wifi network - you can connect to it and setup the WiFi connection (used to keep the clock synchronized). Once setup, the connection settings will persist across reboots.

## Buttons

- If you keep the top left button pressed for more than 5 seconds, it will reset the network settings (see the Usage section).
- If you press the top right button, the display will cycle 3 different levels of brightness.
