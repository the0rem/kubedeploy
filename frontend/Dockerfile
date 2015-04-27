FROM richarvey/nginx-php-fpm

MAINTAINER Shaun Smekel <shaun.smekel@theorem.net.au>

# Add description for the image
LABEL Description="This image creates an environment suitable or deploying Laravel 5 applicaitons."

# Fix problem with php-fpm clearing any environment variables passed
RUN RUN sed -i -e "s/clear_env.*$/clear_env = no/g" /etc/php5/fpm/pool.d/www.conf

# Add Mcrypt
# Run by inherited image # RUN sudo apt-get install php5-mcrypt 
RUN sudo ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available/mcrypt.ini
RUN sudo php5enmod mcrypt
RUN sudo service php5-fpm restart

# Install Composer 
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Pull in project
RUN git clone https://github.com/the0rem/CMS /usr/share/nginx/html

# Change to app directory
WORKDIR /usr/share/nginx/html
RUN composer install --no-dev -o
RUN composer require "predis/predis:~1.0"

# Build app for demo
RUN php artisan app:install

# Start Supervisord
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh