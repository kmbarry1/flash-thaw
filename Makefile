.PHONY: build

all    :; dapp --use solc:0.8.11 build
clean  :; dapp clean
test   : build
	./test.sh
