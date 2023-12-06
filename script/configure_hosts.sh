#!/bin/bash

if [ -z ${DOMAIN} ]
then
	echo 'Error: $DOMAIN is empty'
	exit 1
fi

if ! grep -q ${DOMAIN} "/etc/hosts"; then
	echo "127.0.0.1 ${DOMAIN}" | sudo tee -a /etc/hosts
fi
