# RoboClock

RoboClock is a firmware for the [Pimoroni Scroll
Bot](https://shop.pimoroni.com/products/scroll-bot-pi-zero-w-project-kit?variant=38476730378&gclid=Cj0KCQjwr82iBhCuARIsAO0EAZznNj-lffNXKPynnAZUE9o8-09JADqg8rVW_qU8wyGrcMQSPVyIdR8aAt8jEALw_wcB).

## Setup

Requires:

- [Nix with Flake Support](https://nixos.wiki/wiki/Flakes) or alternatively a
  [functioning environment for Nerves
  development](https://hexdocs.pm/nerves/installation.html).
- a working [direnv](https://direnv.net) installation.
- a working [1Password CLI installation](https://1password.com/downloads/command-line/).

Once cloned:

- `cp .envrc.example .envrc`
- Customize the value of `SSH_PUBLIC_KEY_OP_PATH` to a valid RSA key managed in 1Password.
- Run `direnv allow`

NOTE: to find the correct path, run `op item get <key-name> --format json`, and
look for the `reference` attribute of the `public key` field.

## Development

All common tasks are covered in the included Makefile.

## Installing/updating the firmware

To flash a MicroSD card, use `make firmware.burn`. For over-the-air updates to
a local device, you can then use `make firmware.upload`.

## Usage

On first boot, the device will broadcast a `ROBOCLOCK` wifi network - you can
connect to it and setup the WiFi connection (used to keep the clock
synchronized). Once setup, the connection settings will persist across reboots.

## Buttons

- If you keep the top left button pressed for more than 5 seconds, it will
  reset the network settings (see the Usage section).
- If you press the top right button, the display will cycle 3 different levels
  of brightness.
