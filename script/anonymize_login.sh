#!/bin/bash

if [ -z ${LOGIN} ]
then
	echo 'Error: $LOGIN is empty'
	exit 1
fi

sed -i "s/${LOGIN}/anonymous/g" src/.env
sed -i "s/${LOGIN}/anonymous/g" src/requirement/nginx/nginx.conf
sed -i "s/${LOGIN}/anonymous/g" src/requirement/nginx/Dockerfile
