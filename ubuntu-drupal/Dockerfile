from ubuntu

# install dependencies
RUN apt-get update

# Install generic tools
RUN apt-get install -y vim unzip wget curl mysql-client

# Install Apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2

# Install PHP
RUN apt-get install -y php php-cli php-mbstring php-pdo php-gmp php-xml php-curl php-gd php-imagick php-mysql php-mcrypt php-memcache php-xsl php-opcache php-pear composer libapache2-mod-php

# Composer
ENV COMPOSER_HOME="/opt/composer"
ENV PATH="/opt/composer/vendor/bin:${PATH}"
RUN \
  mkdir /opt/composer && \
  composer global require --no-interaction --update-no-dev phpunit/phpunit:4.8.35 drush/drush drupal/coder squizlabs/php_codesniffer && \
  phpcs --config-set installed_paths /opt/composer/vendor/drupal/coder/coder_sniffer

# Install apache-php
RUN a2enmod rewrite
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

# Install Drupal 8.3
RUN \ 
  wget https://ftp.drupal.org/files/projects/drupal-8.3.x-dev.tar.gz && \
  tar -xf drupal-8.3.x-dev.tar.gz && \
  mv drupal-8.3.x-dev /var/www/web && \
  chown -R www-data /var/www/web && \
  rm -f drupal-8.3.x-dev.tar.gz

# Add drush config, and default.settings.php
ADD drushrc.php /etc/drush/drushrc.php
ADD default.settings.php /var/www/web/sites/default/default.settings.php

# Set up path to use composer
ENV PATH="/root/.composer/vendor/bin:${PATH}"

# TODO: AppArmour

# Tidy up
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Default command
CMD ["apachectl", "-D", "FOREGROUND"]

# Set the working dir
WORKDIR /var/www/

# open port 80
EXPOSE 80

