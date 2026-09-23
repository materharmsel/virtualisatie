# Maarten ter Harmsel
# Studentnummer: 587328
# Week 4 - eigen Docker image (Apache webserver met eigen pagina)

FROM ubuntu:24.04

LABEL maintainer="Maarten ter Harmsel 587328"

RUN apt-get update && apt-get install -y apache2

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
