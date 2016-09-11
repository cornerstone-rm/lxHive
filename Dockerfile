FROM ubuntu:14.04

# Install packages
RUN apt-get update && apt-get install -my \
  curl \
  wget \
  php5 \
  php5-mcrypt

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"

COPY . /var/www/default

WORKDIR /var/www/default

RUN php /composer.phar install

RUN cp src/xAPI/Config/Config.template.yml Config.yml

RUN ./X setup:db
RUN ./X setup:oauth
RUN ./X user:create
