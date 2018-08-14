#!/bin/sh

if [ ! -d $SSH_KEYS_DIRECTORY ]; then
	echo Missing SSH_KEYS_DIRECTORY $SSH_KEYS_DIRECTORY 1>&2
	exit 1
fi

sleep 1

for FILE in $(ls $SSH_KEYS_DIRECTORY)
do
	chmod 600 ${SSH_KEYS_DIRECTORY}/${FILE} 1>&2
	ssh-add ${SSH_KEYS_DIRECTORY}/${FILE} 1>&2
done