#!/bin/bash

export PORT=5100
export MIX_ENV=prod
export GIT_PATH=/home/memory_game/src/memory_game

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "memory_game" ]; then
	echo "Error: must run as user 'memory_game'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/memory_game ]; then
	echo mv ~/www/memory_game ~/old/$NOW
	mv ~/www/memory_game ~/old/$NOW
fi

mkdir -p ~/www/memory_game
REL_TAR=~/src/memory_game/_build/prod/rel/memory_game/releases/0.0.1/memory_game.tar.gz
(cd ~/www/memory_game && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/memory_game/src/memory_game/start.sh
CRONTAB

#. start.sh
