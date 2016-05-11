FROM ubuntu
MAINTAINER philippeassis/apache2 PhilippeAssis <assis@philippeassis.com>

# Setup environment
ENV DEBIAN_FRONTEND noninteractive

# Update sources
RUN apt-get update -y
RUN apt-get install -y software-properties-common python-software-properties nano bash-completion unzip python3

################################################
# APACHE2
################################################
RUN apt-get install -y apache2
RUN mkdir -p /var/lock/apache2 /var/run/apache2

RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

################################################
# SSH
################################################
RUN apt-get install -y openssh-server openssh-client passwd
RUN mkdir -p /var/run/sshd

RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN echo 'root:root' | chpasswd
RUN mkdir -p /root/.ssh && touch /root/.ssh/authorized_keys && chmod 700 /root/.ssh

################################################
# GIT
################################################
RUN apt-get install -y git

RUN bash &&\
   echo "alias www='cd /var/www/html'" >> ~/.bash_aliases &&\
   echo "alias gitall='git add --all && git commit -m \"commit\" && git push origin master'" >> ~/.bash_aliases

################################################
# Configs
################################################

VOLUME ["/var/www/html"]

EXPOSE 80 22

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
