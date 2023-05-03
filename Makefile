firwmare.burn:
	MIX_TARGET=rpi0 mix do deps.get, firmware, firmware.burn
.PHONY: firmware.burn

firmware.upload: firmware
	./upload roboclock.local
.PHONY: firmware.upload

firmware:
	MIX_TARGET=rpi0 mix do deps.get, firmware
.PHONY: firmware

ssh:
	ssh roboclock.local
.PHONY: ssh

ping:
	ping roboclock.local
.PHONY: ping
