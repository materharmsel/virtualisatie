# Maarten ter Harmsel
# Studentnummer: 587328
# Week 4

FROM ubuntu:24.04

LABEL maintainer="Maarten ter Harmsel 587328"

RUN apt-get update && apt-get install -y apache2

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

COPY index.html /var/www/html/index.html

COPY over.html /var/www/html/over.html

ADD style.css /var/www/html/style.css

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
