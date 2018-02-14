#!/bin/bash

export PORT=5100

cd ~/www/memory_game
./bin/memory_game stop || true
./bin/memory_game start
