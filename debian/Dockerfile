ARG APACHE_VERSION=2.4

FROM httpd:${APACHE_VERSION} as build

ARG MELLON_VERSION=0.16.0

RUN apt-get update && \
  apt-get install build-essential apache2-dev liblasso3 pkg-config liblasso3-dev libcurl4-openssl-dev curl libxmlsec1 libxmlsec1-dev ca-certificates -y

# Compile & install mod_auth_mellon
RUN mkdir /tmp/mod_auth_mellon && \
  curl -L https://github.com/latchset/mod_auth_mellon/archive/v${MELLON_VERSION}.tar.gz | tar -xvz -C /tmp/mod_auth_mellon --strip 1 && \
  cd /tmp/mod_auth_mellon && \
  autoreconf && \
  ./configure --with-apxs2=/usr/local/apache2/bin/apxs && \
  make && \
  make install

FROM httpd:${APACHE_VERSION}
RUN apt update && apt install openssl liblasso3 libxmlsec1 -y

# copy mellon_create_metadata.sh
COPY --from=build /tmp/mod_auth_mellon/mellon_create_metadata.sh /usr/sbin/
RUN chmod +x /usr/sbin/mellon_create_metadata.sh

COPY --from=build /usr/local/apache2/modules/mod_auth_mellon.so /usr/local/apache2/modules/mod_auth_mellon.so
