FROM richarvey/nginx-php-fpm

MAINTAINER Shaun Smekel <shaun.smekel@theorem.net.au>

# Add description for the image
LABEL Description="This image creates an environment suitable or deploying Laravel 5 applicaitons."

# Add Mcrypt
# Run by inherited image # RUN sudo apt-get install php5-mcrypt 
RUN sudo ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available/mcrypt.ini
RUN sudo php5enmod mcrypt
RUN sudo service php5-fpm restart

# Install Composer 
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

