FROM debian:bullseye

# Expose ports
EXPOSE 9000
EXPOSE 3306

# Install
RUN apt update
RUN apt install -y curl
RUN apt install -y php7.4 php-fpm php-mysql
RUN apt install -y mariadb-client

# Configure PHP
RUN sed -i 's/^listen = .*/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Install wp-cli
RUN mkdir -p /var/www/html/wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/.

# Copy setup script
COPY setup_wp.sh /tmp/setup_wp.sh
RUN chmod +x /tmp/setup_wp.sh

# Needed to bind listening socket
RUN mkdir -p /run/php

ENTRYPOINT ["/tmp/setup_wp.sh"]
