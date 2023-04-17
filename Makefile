firwmare.burn:
	MIX_TARGET=rpi0 mix do deps.get, firmware, firmware.burn
.PHONY: firmware.burn

firmware.upload:
	MIX_TARGET=rpi0 mix firmware
	./upload roboclock.local
.PHONY: firmware.upload

ssh:
	ssh roboclock.local
.PHONY: ssh

ping:
	ping roboclock.local
.PHONY: ping
