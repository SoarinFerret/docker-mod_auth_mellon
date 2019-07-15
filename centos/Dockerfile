FROM centos/httpd:latest AS build

ARG MELLON_VERSION=0.14.2



# Install mod_auth_mellon
RUN mkdir /tmp/mod_auth_mellon && \
  curl -L https://github.com/Uninett/mod_auth_mellon/archive/v${MELLON_VERSION}.tar.gz | tar -xvz -C /tmp/mod_auth_mellon --strip 1 && \
  cd /tmp/mod_auth_mellon && \
  aclocal && \
  autoheader && \
  autoconf && \
  ./configure --with-apxs2=/usr/local/apache2/bin/apxs && \
  make && \
  make install


FROM centos/httpd:latest


# Add mellon_create_metadata.sh
RUN mkdir /etc/httpd/mellon \
        && wget -P /usr/sbin/ https://raw.githubusercontent.com/Uninett/mod_auth_mellon/master/mellon_create_metadata.sh \
        && chmod +x /usr/sbin/mellon_create_metadata.sh

# Expose and Launch Apache
EXPOSE 80
ENTRYPOINT ["httpd" "-DFOREGROUND"]