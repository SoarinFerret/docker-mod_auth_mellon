FROM httpd:alpine AS build

ARG MELLON_VERSION=0.14.2
ARG XMLSEC_VERSION=1.2.28
ARG LASSO_VERSION=2.5.1

RUN apk --update add \
  autoconf \
  automake \
  curl-dev \
  g++ \
  glib-dev \
  libtool \
  libxml2-dev \
  make \
  perl-dev \
  py-six \
  python \
  xmlsec-dev \
  zlib-dev \
  curl

# Install xmlsec
RUN mkdir /tmp/xmlsec && \
  curl -L https://www.aleksey.com/xmlsec/download/xmlsec1-${XMLSEC_VERSION}.tar.gz | tar -xvz -C /tmp/xmlsec --strip 1 && \
  cd /tmp/xmlsec && \
  ./configure --enable-soap && \
  make && \
  make install

# Install lasso
RUN mkdir /tmp/lasso && \
  curl -L https://dev.entrouvert.org/releases/lasso/lasso-${LASSO_VERSION}.tar.gz | tar -xvz -C /tmp/lasso --strip 1 && \
  cd /tmp/lasso && \
  ./configure && \
  make && \
  make install

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

FROM httpd:alpine
RUN apk --no-cache add glib curl libxslt libltdl

# copy mellon_create_metadata.sh
COPY --from=build /tmp/mod_auth_mellon/mellon_create_metadata.sh /usr/sbin/
RUN chmod +x /usr/sbin/mellon_create_metadata.sh

# Copy compiled mellon
COPY --from=build /usr/local/apache2/modules/mod_auth_mellon.so /usr/local/apache2/modules/mod_auth_mellon.so
COPY --from=build /usr/local/lib/liblasso* /usr/local/lib/
COPY --from=build /usr/local/lib/libxmlsec1* /usr/local/lib/

# alter httpd.conf to include files from conf.d and open 443
RUN sed -i '/<IfModule ssl_module>/a Listen 443' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/<IfModule proxy_html_module>/i IncludeOptional conf.d/*.conf' /usr/local/apache2/conf/httpd.conf
