#!/usr/bin/make
## makefile
##
## Copyright 2016 Mac Radigan
## All Rights Reserved

.PHONY: build clean run shell

name = radiganm/xcom

build: 
	docker build -t $(name) .

run: 
	Xephyr -ac -br -resizeable -terminate -reset :3 2>/dev/null 1>/dev/null &
	docker run -it --ipc=host --pid=host -e DISPLAY=:3 -e $(XAUTHORITY) -v /tmp:/tmp --security-opt seccomp=unconfined $(name) start

shell: 
	docker run -it -e DISPLAY -v /tmp/.X11-unix:/tmp.X11-unix:ro $(name) util shell

clean: 
	docker ps -a --no-trunc | grep $(name) | awk '{print$$1}' | xargs -I{} docker stop {}
	docker images -a --no-trunc | grep $(name) | awk '{print$$3}' | xargs -I{} docker rmi -f {}

## *EOF*
