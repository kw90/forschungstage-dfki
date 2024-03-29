# --------------------------------------------------------------------
# Copyright (c) 2019 Saarbrücken, Germany. All Rights Reserved.
# Author(s): Kai Waelti
#
# Credit to: Anthony Potappel for inspiration
# https://itnext.io/docker-makefile-x-ops-sharing-infra-as-code-parts-ea6fa0d22946
# This software may be modified and distributed under the terms of the
# MIT license. See the LICENSE file for details.
# --------------------------------------------------------------------

# If you see pwd_unknown showing up, this is why. Re-calibrate your system.
PWD ?= pwd_unknown

# PROJECT_NAME defaults to name of the current directory.
# should not to be changed if you follow GitOps operating procedures.
PROJECT_NAME = $(notdir $(PWD))

# Note. If you change this, you also need to update docker-compose.yml.
# only useful in a setting with multiple services/ makefiles.
SERVICE_TARGET := main

# if vars not set specifially: try default to environment, else fixed value.
# strip to ensure spaces are removed in future editorial mistakes.
# tested to work consistently on popular Linux flavors and Mac.
ifeq ($(user),)
# USER retrieved from env, UID from shell.
HOST_USER ?= $(strip $(if $(USER),$(USER),nodummy))
HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),4000))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER = $(user)
HOST_UID = $(strip $(if $(uid),$(uid),0))
endif

THIS_FILE := $(lastword $(MAKEFILE_LIST))
#CMD_ARGUMENTS ?= $(cmd)
FILE_ARGUMENTS ?= $(file)

# export such that its passed to shell functions for Docker to pick up.
export PROJECT_NAME
export HOST_USER
export HOST_UID

# all our targets are phony (no files to check).
.PHONY: build remove slides watch

.INTERMEDIATE: remove

# suppress makes own output
#.SILENT:

slides:
	build
ifeq ($(strip $(FILE_ARGUMENTS)),)
	# no command is given, give default run command
	docker run --name pandoc-latex --volume `pwd`:/data -e OUTPUT_FILENAME=$(PROJECT_NAME) kw90/pandoc-latex:latest
else
	# run the command
	docker run --name pandoc-latex --volume `pwd`:/data kw90/pandoc-latex:latest pandoc -t beamer "$(FILE_ARGUMENTS)" -o "$(FILE_ARGUMENTS)".pdf
endif

# Regular Makefile part for buildpypi itself
help:
	@echo ''
	@echo 'Usage: make [TARGET] [EXTRA_ARGUMENTS]'
	@echo 'Targets:'
	@echo '  build      run docker build command for container'
	@echo '  slides     run pandoc-latex --container-- for current dir and README.md file'
	@echo '             Takes extra argument `file` to indicate a input file for conversion'
	@echo '             Use make slides file="input.md" or make file="input.md" to generate input.pdf'
	@echo '  remove     remove pandoc-latex container from containers'
	@echo '  prune      prune docker system of all container, images and volumes (USE WITH CARE)'
	@echo ''
	@echo 'Extra arguments:'
	@echo 'file=:	make file="FILENAME.md"'
	@echo '# user= and uid= allows to override current user. Might require additional privileges.'
	@echo 'user=:	make shell user=root (no need to set uid=0)'
@echo 'uid=:	make shell user=dummy uid=4000 (defaults to 0 if user= set)'

watch:
	@echo $@
	-docker run --name pandoc-latex -dt --entrypoint "/bin/sh" --volume `pwd`:/data kw90/pandoc-latex:latest
ifeq ($(strip $(FILE_ARGUMENTS)),)
	# no filename given, give default project name and use README.md
	docker exec pandoc-latex watchexec -e md -r "pandoc -t beamer README.md -o $(PROJECT_NAME).pdf"
else
	# run with given filename and output $(FILE_ARGUMENTS).pdf
	docker exec pandoc-latex watchexec -e md -r "pandoc -t beamer $(FILE_ARGUMENTS).md -o $(FILE_ARGUMENTS).pdf"
endif

build:
	docker build -t pandoc-latex .

remove:
	docker stop pandoc-latex && docker rm pandoc-latex

prune:
	docker system prune -a
