FROM richarvey/nginx-php-fpm

MAINTAINER Shaun Smekel <shaun.smekel@theorem.net.au>

# Add description for the image
LABEL Description="This image creates an environment suitable or deploying Laravel 5 applicaitons."

# Fix problem with php-fpm clearing any environment variables passed
RUN sed "s/clear_env.*$/clear_env = no/g" -i /etc/php5/fpm/pool.d/www.conf

# Add Mcrypt
# Run by inherited image # RUN sudo apt-get install php5-mcrypt 
RUN sudo php5enmod mcrypt
RUN sudo service php5-fpm restart

# Install Composer 
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN mkdir -p /root/.ssh
ADD ./id_rsa /root/.ssh/id_rsa
ADD ./id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Pull in project
RUN rm -rf /usr/share/nginx/html/*
RUN git clone https://github.com/the0rem/CMS /usr/share/nginx/html

# Change to app directory
WORKDIR /usr/share/nginx/html
RUN composer install --no-dev -o
RUN composer require "predis/predis:~1.0"

RUN rm /root/.ssh/id_rsa

# Build app for demo
#RUN php artisan app:install

# Start Supervisord
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh