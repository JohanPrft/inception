FROM debian:bullseye

# Expose ports
EXPOSE 443/tcp
EXPOSE 9000

# Install
RUN apt update
RUN apt install -y nginx openssl

# Create ssl certificates
RUN mkdir -p /etc/nginx/certs/
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt -subj "/CN=anonymous.42.fr"

# Configure nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g" ,"daemon off;"]
