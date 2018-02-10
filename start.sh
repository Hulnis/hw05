#!/bin/bash

export PORT=5101

cd ~/www/hw05
./bin/memory_game stop || true
./bin/memory_game start
