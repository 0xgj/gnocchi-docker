FROM python:2.7
MAINTAINER CAOGAOJIN <caogaojin@cmss.chinamobile.com>

RUN apt-get -yq update && \
    apt-get -yqq install apache2 libapache2-mod-wsgi \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

COPY gnocchi /opt/gnocchi
COPY gnocchiclient /opt/gnocchiclient

RUN pip install -r /opt/gnocchi/requirements.txt
RUN pip install -r /opt/gnocchiclient/requirements.txt
RUN cd /opt/gnocchi && python setup.py install
RUN cd /opt/gnocchiclient && python setup.py install
RUN pip install influxdb

COPY etc /etc/gnocchi
RUN rm -rf /root/.pip && \
    rm -rf /etc/apache2/sites-enabled/*

COPY start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh && \
    useradd -m gnocchi && \
    mkdir -p /var/www/gnocchi/ 

COPY apache2/apache2_gocchi.conf /etc/apache2/sites-enabled/gnocchi.conf
COPY apache2/app.wsgi /var/www/gnocchi/app.wsgi

EXPOSE 8041

WORKDIR /opt/

CMD ["apache2ctl", "-DFOREGROUND"]
ENTRYPOINT ["start.sh"]
