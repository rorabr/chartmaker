# Makefile for installing chartmaker - https://github.com/rorabr/chartmaker
# Must be run as root to install in /usr/local/bin

src=chartmaker
dst=/usr/local/bin
perl=$(shell which perl)

all: check install

# perform some checks on the source, perl and destination
check:
	$(if ${perl},,$(error perl executable not found))
	$(if $(wildcard ${src}),,$(error source file ${src} not found, make sould be run in the projects main directory))
	$(if $(wildcard ${dst}),,$(error destination directory ${dst} not found))
	$(eval owner := $(shell ls -lad ${dst} | awk '{print $$3}'))
	$(eval group := $(shell ls -lad ${dst} | awk '{print $$4}'))
	@echo "Instalation checks ok"

install: check
	install -D --mode=0755 --owner=${owner} --group=${group} ${src} ${dst}/${src}
	@echo "${src} installed on ${dst}"
