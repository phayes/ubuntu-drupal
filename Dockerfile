from ubuntu

# install dependencies
RUN apt-get update

# Install generic tools
RUN apt-get install -y vim unzip wget curl

# Install Apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2

# Install PHP
RUN apt-get install -y php php-cli php-mbstring php-pdo php-gmp php-xml php-curl php-gd php-imagick php-mysql php-mcrypt php-memcache php-xsl php-opcache drush phpunit composer libapache2-mod-php

# Install drush (drush requires mysql-client)
RUN composer global require drush/drush
RUN apt-get install -y mysql-client

# Install apache-php
RUN a2enmod rewrite
ADD apache2.conf /etc/apache2/apache2.conf

# Install Drupal 8.3
RUN \ 
  wget https://ftp.drupal.org/files/projects/drupal-8.3.x-dev.tar.gz && \
  tar -xf drupal-8.3.x-dev.tar.gz && \
  rm -rf /var/www/html && \
  mv drupal-8.3.x-dev /var/www/html && \
  chown -R www-data /var/www/html && \
  chmod -R og+w /var/www/html && \
  rm -f drupal-8.3.x-dev.tar.gz

# Add php config, drush config, and default.settings.php
ADD php.ini /etc/php.ini
ADD drushrc.php /etc/drush/drushrc.php
ADD default.settings.php /var/www/html/sites/default/default.settings.php
ADD default.settings.php /var/www/html/sites/default/settings.php

# Set up path to use composer
ENV PATH="/root/.composer/vendor/bin:${PATH}"

# Tidy up
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Default command
CMD ["apachectl", "-D", "FOREGROUND"]

# Set the working dir to make running drush easy
WORKDIR /var/www/html

# Set environment variable for testing
ENV SIMPLETEST_BASE_URL http://localhost

# open port 80
EXPOSE 80

