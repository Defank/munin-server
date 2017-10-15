FROM debian:stretch
MAINTAINER Stanislav <denfas112@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y supervisor cron nginx wget patch spawn-fcgi libcgi-fast-perl && \
apt-get install -y munin munin-node && \
rm -r /var/lib/apt/lists/*

RUN rm -rf /etc/nginx/sites-available && \
rm -rf /etc/nginx/sites-enabled && \
mkdir -p /var/cache/munin/www && \
chown munin:munin /var/cache/munin/www && \
mkdir -p /var/run/munin && \
chown -R munin:munin /var/run/munin && \
chmod -R a+rX /var/log

#---supervisord
RUN mkdir -p /var/log/supervisor
COPY ./scripts/start.sh /start.sh
RUN chmod +x  /start.sh
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# munin, nginx files
ADD ./munin.conf /etc/munin/munin.conf
ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./nginx-munin.conf /etc/nginx/conf.d

#other plugins
RUN rm -rf /etc/munin/plugins/* && \
    ln -s /usr/share/munin/plugins/uptime /etc/munin/plugins && \
    ln -s /usr/share/munin/plugins/cpu /etc/munin/plugins && \
    ln -s /usr/share/munin/plugins/memory /etc/munin/plugins && \
    ln -s /usr/share/munin/plugins/load /etc/munin/plugins

EXPOSE 8080

CMD ["/usr/bin/supervisord"]