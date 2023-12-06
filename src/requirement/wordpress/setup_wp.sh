#!/bin/bash

echo "Waiting for MariaDB"
while ! mariadb --host=${SQL_HOST} --user=${SQL_USER} --password=${SQL_USER_PASSWORD} &>/dev/null;
do
    sleep 1
done
echo "MariaDB accessible"

if wp-cli.phar core is-installed --path=${WP_PATH} --allow-root;
then
	echo "WordPress already configured."
else
	echo "Setting up WordPress"

	echo "Downloading WordPress on ${WP_PATH}"
	wp-cli.phar core download	--path=${WP_PATH}					\
								--allow-root

	echo "Creating wp-config.php"
	wp-cli.phar config create	--dbname=${SQL_DATABASE}			\
								--dbuser=${SQL_USER} 				\
								--dbpass=${SQL_USER_PASSWORD}		\
								--dbhost=${SQL_HOST} 				\
								--path=${WP_PATH} 					\
								--allow-root

	echo "Installing WordPress core"
	wp-cli.phar core install	--url=${DOMAIN_NAME}/wordpress		\
								--title=${WP_TITLE}					\
								--admin_user=${WP_ADMIN_USER}		\
								--admin_password=${WP_ADMIN_PASS}	\
								--admin_email=${WP_ADMIN_EMAIL}		\
								--path=${WP_PATH}					\
								--allow-root

	echo "Creating WordPress default user"
	wp-cli.phar user create		$WP_USER ${WP_USER_EMAIL}			\
								--user_pass=${WP_USER_PASS}			\
								--role=subscriber					\
								--display_name=${WP_USER}			\
								--porcelain							\
								--path=${WP_PATH}					\
								--allow-root
fi

#-R Reload, -F Force foreground
echo -e "${GREEN}Starting wordpress FastCGI Process Manager on port 9000${RESET}"
exec /usr/sbin/php-fpm7.4 -R -F
