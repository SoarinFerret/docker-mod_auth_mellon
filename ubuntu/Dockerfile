FROM ubuntu:latest

# Install Apache
RUN apt update && apt install -y \
        openssl \
        apache2 \
        libapache2-mod-ssl \
        wget \
        && rm -rf /var/lib/apt/lists/*

# Install mod-auth-mellon (0.14.1) from disco
RUN echo "deb http://cz.archive.ubuntu.com/ubuntu disco main" >> /etc/apt/sources.list \
        && apt update \
        && apt install libapache2-mod-auth-mellon -y \
        && sed -i '/disco/d' /etc/apt/sources.list \
        && rm -rf /var/lib/apt/lists/*

# Add mellon_create_metadata.sh
RUN wget -P /usr/sbin/ https://raw.githubusercontent.com/Uninett/mod_auth_mellon/master/mellon_create_metadata.sh \
        && chmod +x /usr/sbin/mellon_create_metadata.sh \
        && mkdir /etc/apache2/mellon

# Enable apache mods
RUN a2enmod headers proxy proxy_http ssl proxy_wstunnel rewrite_module

# Expose and Launch Apache
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]