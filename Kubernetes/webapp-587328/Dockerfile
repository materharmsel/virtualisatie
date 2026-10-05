# Maarten ter Harmsel
# Studentnummer: 587328
# Week 6 - Image voor de webapplicatie in Kubernetes
# Bouwen: docker build -t webapp-587328:v1 --build-arg VERSIE=1 .
#         docker build -t webapp-587328:v2 --build-arg VERSIE=2 .

FROM nginx:1.29-alpine

LABEL maintainer="Maarten ter Harmsel 587328"

ARG VERSIE=1

COPY default.conf /etc/nginx/conf.d/default.conf

COPY index.html /usr/share/nginx/html/index.html

RUN sed -i "s/__VERSIE__/${VERSIE}/g" /usr/share/nginx/html/index.html

EXPOSE 80
