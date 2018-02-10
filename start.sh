#!/bin/bash

export PORT=5101

cd ~/www/hw05
./bin/hw05 stop || true
./bin/hw05 start
