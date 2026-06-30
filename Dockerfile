# You can change this to a different version of Wordpress available at
# https://hub.docker.com/_/wordpress
FROM wordpress:latest

RUN apt-get update && apt-get install -y magic-wormhole

RUN usermod -s /bin/bash www-data
RUN chown www-data:www-data /var/www

COPY user.ini /usr/local/etc/php/conf.d/wordpress-custom.ini

# Cap Apache workers to prevent OOM
RUN echo "<IfModule mpm_prefork_module>\n\
    StartServers 2\n\
    MinSpareServers 1\n\
    MaxSpareServers 3\n\
    MaxRequestWorkers 4\n\
    MaxConnectionsPerChild 200\n\
</IfModule>" > /etc/apache2/conf-available/mpm-custom.conf \
  && a2enconf mpm-custom
