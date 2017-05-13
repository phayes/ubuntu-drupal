from phayes/ubuntu-drupal

# install dependencies
RUN apt-get update

# Install xdebug
RUN apt-get install -y php-xdebug

# Automatically add settings.php
ADD default.settings.php /var/www/web/sites/default/default.settings.php
ADD default.settings.php /var/www/web/sites/default/settings.php

# Set perms on settings.php
RUN \
  chown www-data /var/www/web/sites/default/settings.php && \
  chgrp www-data /var/www/web/sites/default/settings.php

# Set-up apache for testing
# Now to run tests: docker exec unbuntu-drupal-dev runtests
ADD runtests /usr/local/bin/runtests
RUN \
  chsh www-data -s /bin/bash && \
  chmod u+x /usr/local/bin/runtests

# Default command
CMD ["apachectl", "-D", "FOREGROUND"]

# Set the working dir
WORKDIR /var/www

# Set environment variable for testing
ENV SIMPLETEST_BASE_URL http://localhost

# open port 80
EXPOSE 80

