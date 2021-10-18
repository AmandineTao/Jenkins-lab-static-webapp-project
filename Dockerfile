#Grab the ubuntu image
FROM ubuntu
LABEL maintainer='Amandine SIMO'
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx git
RUN rm -Rf /var/www/html/*
RUN git clone https://github.com/AmandineTao/static-website-example.git /var/www/html/
EXPOSE 5000
ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]