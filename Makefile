MAKE ?= /usr/bin/make

all:
	[ -x ./mk ] && ./mk
	$(MAKE) mrproper &>/dev/null

clean:
	rm -f bundle.*

mrproper:
	$(MAKE) clean
	[ -d tmp ] && rm -rf tmp
	[ -d tmp ] || mkdir tmp
