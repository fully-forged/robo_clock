firwmare:
	MIX_TARGET=rpi0 mix do deps.get, firmware, firmware.burn
.PHONY: firmware

ssh:
	ssh roboclock.local
.PHONY: ssh

ping:
	ping roboclock.local
.PHONY: ping
