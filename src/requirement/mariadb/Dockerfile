FROM debian:bullseye

# Expose ports
EXPOSE 3306

# Install
RUN apt update
RUN apt install mariadb-server -y

# Copy
COPY create_db.sh /tmp/create_db.sh
RUN chmod +x /tmp/create_db.sh

ENTRYPOINT ["/tmp/create_db.sh"]
