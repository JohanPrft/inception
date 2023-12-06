#!/bin/bash

if [ -z ${LOGIN} ]
then
	echo 'Error: $LOGIN is empty'
	exit 1
fi

sed -i "s/anonymous/${LOGIN}/g" src/.env
sed -i "s/anonymous/${LOGIN}/g" src/requirement/nginx/nginx.conf
sed -i "s/anonymous/${LOGIN}/g" src/requirement/nginx/Dockerfile
