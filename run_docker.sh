#!/bin/sh
docker run --mount "type=bind,src=$(pwd)/mnt/volume1,dst=/mnt/volume1" -i -t bash:v2
