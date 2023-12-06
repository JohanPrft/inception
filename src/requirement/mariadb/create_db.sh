#!/bin/bash

echo "Starting MariaDB"
service mariadb start

if [ ! -d "/var/lib/mysql/$SQL_DATABASE" ]; then
	#not using mariadb-secure-installation because it's interactive
	#but theses lines do the same

	echo "mysql_secure_installation"

	mysql_secure_installation <<EOF

y
${SQL_ROOT_PASSWORD}
${SQL_ROOT_PASSWORD}
y
y
y
y
EOF

	echo "Setting up database (${SQL_DATABASE})"

	mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
			CREATE USER IF NOT EXISTS '${SQL_USER}'@'localhost' IDENTIFIED BY '${SQL_USER_PASSWORD}';
			GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_USER_PASSWORD}';
			ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
			FLUSH PRIVILEGES;"

	echo "Modifying mysql conf"
	echo "port = 3306
	[mysqld]
	bind-address = *" >> /etc/mysql/my.cnf
else
	echo "MariaDB already installed"
fi

echo "Shutting down MariaDB to apply changes"
mariadb-admin -u root -p${SQL_ROOT_PASSWORD} shutdown

echo -e "${GREEN}Starting MariaDB in foreground${RESET}"
exec mysqld_safe -u ${SQL_USER}
