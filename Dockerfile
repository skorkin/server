From debian:buster 
RUN apt-get update
RUN apt-get -y install wget
RUN apt-get -y install nginx
RUN apt-get -y install vim
RUN apt-get -y install mariadb-server
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

#nginx
COPY ./srcs/nginx.conf /etc/nginx/sites-available
RUN ln /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

#phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english /var/www/html/phpmyadmin
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin
#wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN mv wordpress /var/www/html
COPY ./srcs/wp-config.php /var/www/html/wordpress

#ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=KR/ST=RU/L=Moscow/O=Bzelda" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

COPY ./srcs/run.sh ./

RUN chmod -R 755 /var/www/*

CMD bash run.sh


