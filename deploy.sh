#!/bin/bash

export PORT=5101
export MIX_ENV=prod
export GIT_PATH=/home/hw05/src/hw05

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "hw05" ]; then
	echo "Error: must run as user 'hw05'"
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
if [ -d ~/www/hw05 ]; then
	echo mv ~/www/hw05 ~/old/$NOW
	mv ~/www/hw05 ~/old/$NOW
fi

mkdir -p ~/www/hw05
REL_TAR=~/src/hw05/_build/prod/rel/hw05/releases/0.0.1/hw05.tar.gz
(cd ~/www/hw05 && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/hw05/src/hw05/start.sh
CRONTAB

#. start.sh
