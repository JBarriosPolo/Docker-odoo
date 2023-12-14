# Image: ubuntu:latest
 FROM ubuntu:latest
 # etiqueta de metadatos
 LABEL version="2.0" description="esta imagen contiene una version estable de odoo 16" author="Jesus Barrios"
 # ejecucion de variables
 RUN apt update && apt upgrade -y && apt install nano -y && \
     apt install sudo -y && \
     adduser --system --quiet --shell=/bin/bash --home=/opt/odoo --gecos 'odoo' --group odoo && \
     mkdir /etc/odoo && mkdir /var/log/odoo && \
     apt install debconf-utils -y && \
     echo "tzdata tzdata/Areas select America" | debconf-set-selections && \
     echo "tzdata tzdata/Zones/America select Panama" | debconf-set-selections && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-server-dev-14 && \
     service postgresql start && \
     su - postgres -c "createuser -s odoo" && \
     apt install wget git python3 python3-pip build-essential python3-dev  libldap2-dev  libsasl2-dev python3-setuptools libjpeg-dev nodejs npm -y && \
     git clone --depth 1 --branch 16.0 https://github.com/odoo/odoo /opt/odoo/odoo && \
     chown odoo:odoo /opt/odoo/ -R && \
     chown odoo:odoo /var/log/odoo/ -R && \
     pip3 install cffi && \
     pip3 install -r /opt/odoo/odoo/requirements.txt && \
     apt install fontconfig xfonts-base xfonts-75dpi -y && \
     #
     ## debera ponerse en contacto con el creador de esta documentacion el resto de codigo
     #
     ln -s /usr/local/bin/wkhtmltopdf /usr/bin/ && \
     ln -s /usr/local/bin/wkhtmltoimage /usr/bin/ && \
     su - odoo -c "/opt/odoo/odoo/odoo-bin --addons-path=/opt/odoo/odoo/addons -s --stop-after-init" && \
     mv /opt/odoo/.odoorc /etc/odoo/odoo.conf && \
     sed -i "s,^\(logfile = \).*,\1"/var/log/odoo/odoo-server.log"," /etc/odoo/odoo.conf && \
     cp /opt/odoo/odoo/debian/init /etc/init.d/odoo && sudo chmod +x /etc/init.d/odoo && \
     ln -s /opt/odoo/odoo/odoo-bin /usr/bin/odoo && \
     update-rc.d -f odoo start 20 2 3 4 5 .