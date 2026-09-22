# Maarten ter Harmsel
# Studentnummer: 587328
# Week 4 - eigen Docker image (Apache webserver met eigen pagina)

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y apache2 && rm -rf /var/lib/apt/lists/*

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
