# mod_auth_mellon Docker Containers

From [latchset/mod_auth_mellon](https://github.com/latchset/mod_auth_mellon):

> mod_auth_mellon is an authentication module for Apache. It authenticates the user against a SAML 2.0 IdP, and grants access to directories depending on attributes received from the IdP.

This is a repository for unoffical builds of mod_auth_mellon and packaged as Docker images at [soarinferret/mod_auth_mellon](https://hub.docker.com/r/soarinferret/mod_auth_mellon). These images use the official [httpd docker image](https://hub.docker.com/_/httpd).

## Supported Tags

* [latest, alpine, 0.16.0-alpine](https://github.com/SoarinFerret/docker-mod_auth_mellon/blob/master/alpine/Dockerfile)
* [debian, 0-16.0-debian](https://github.com/SoarinFerret/docker-mod_auth_mellon/blob/master/debian/Dockerfile)
* [0.15.0-alpine](https://github.com/SoarinFerret/docker-mod_auth_mellon/blob/master/alpine/Dockerfile)
* [0.15.0-debian](https://github.com/SoarinFerret/docker-mod_auth_mellon/blob/master/debian/Dockerfile)
* [0.14.2-alpine](https://github.com/SoarinFerret/docker-mod_auth_mellon/blob/master/alpine/Dockerfile)
* [0.14.2-debian](https://github.com/SoarinFerret/docker-mod_auth_mellon/blob/master/debian/Dockerfile)

## How to use this image

In order to use SAML functions of this container, you will need to provide a `.conf` file with the configuration you need. A sample config file is provided under `example/saml.conf`. This sample conf file is setup to be used as a way of proxying SAML in front of another application, and sending it to a backend service with the `REMOTE_USER` http header set.

```bash
$ docker run -v ${PWD}/saml.conf:/usr/local/apache2/conf.d/saml.conf \
             -p 80:80 -p 443:443 -d \
             soarinferret/mod_auth_mellon:latest
```

A sample `docker-compose.yml` file is also provided.

```bash
$ docker-compose up -d
```

### Generate Signing Certs

The mod_auth_mellon repository provides a convienent script to generate SSL certs for signing SAML requests, in addition to sample XML. That script has been included in these images. 

_Note_: The alpine image by default does not include OpenSSL, which is required by the script. Make sure you install it before running the script

```bash
$ # Using the Alpine Image
$ docker run -it -w="/mellon" \
             -v ${PWD}:/mellon:rw \
             --rm soarinferret/mod_auth_mellon:alpine \
             sh -c "apk add openssl; mellon_create_metadata.sh https://saml.example.com https://saml.example.com"
$
$ # Using the Debian Image
$ docker run -it -w="/mellon" \
             -v ${PWD}:/mellon:rw \
             --rm soarinferret/mod_auth_mellon:debian \
             sh -c "mellon_create_metadata.sh https://saml.example.com https://saml.example.com"
```

Sample Output:

```
Output files:
Private key:               https_saml.example.com.key
Certificate:               https_saml.example.com.cert
Metadata:                  https_saml.example.com.xml

Host:                      saml.example.com

Endpoints:
SingleLogoutService:       https://saml.example.com/logout
AssertionConsumerService:  https://saml.example.com/postResponse

```

## Build them yourself

I have provided a PowerShell script to build the images if you would like. Otherwise, you may build it manually. Additionally, I have added build arguments for versions of Apache and versions of mod_auth_mellon.

```bash
$ git clone https://github.com/SoarinFerret/docker-mod_auth_mellon.git mellon
$ cd mellon
$
$ # Alpine Build
$ docker build --rm --build-arg APACHE_VERSION=2.4.38 --build-arg=0.14.2 -f "alpine/Dockerfile" -t mellon:alpine alpine
$ # Debian Build
$ docker build --rm --build-arg APACHE_VERSION=2.4.38 --build-arg=0.14.2 -f "debian/Dockerfile" -t mellon:debian debian
```

## Docs / Resources

* [latchset/mod_auth_mellon GitHub Repo](https://github.com/latchset/mod_auth_mellon/)
* [Mellon User Guide](https://github.com/latchset/mod_auth_mellon/blob/master/doc/user_guide/mellon_user_guide.adoc)