FROM ubuntu:14.04
MAINTAINER philippeassis/apache2 PhilippeAssis <assis@philippeassis.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y openssh-server software-properties-common python-software-properties nano bash-completion unzip python3 supervisor apache2

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

################################################
# APACHE2
################################################
RUN mkdir -p /var/lock/apache2 /var/run/apache2
RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf && a2enmod rewrite


################################################
# SUPERVISOR
################################################
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME ["/var/www/html"]

EXPOSE 22 80

CMD ["/usr/bin/supervisord"]
