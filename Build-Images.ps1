#!/usr/bin/pwsh

Param(
    $ApacheVersion = "2.4",
    $MellonVersion = "0.15.0",

    #Alpine Only Args
    $XmlSecVersion = "1.2.28",
    $LassoVersion = "2.6.0",

    $Image = "soarinferret/mod_auth_mellon",
    [switch]$DebianOnly,
    [switch]$AlpineOnly,
    [switch]$Push
)

# Alpine / Latest
if(!$DebianOnly){
    docker build --rm `
                --build-arg APACHE_VERSION=$ApacheVersion `
                --build-arg MELLON_VERSION=$MellonVersion `
                --build-arg XMLSEC_VERSION=$XmlSecVersion `
                --build-arg LASSO_VERSION=$LassoVersion `
                -f "alpine/Dockerfile" `
                -t $Image`:$MellonVersion-alpine `
                -t $Image`:latest `
                -t $Image`:alpine `
                "alpine"
}

# Debian
if(!$AlpineOnly){
    docker build --rm `
                --build-arg APACHE_VERSION=$ApacheVersion `
                --build-arg MELLON_VERSION=$MellonVersion `
                -f "debian/Dockerfile" `
                -t $Image`:$MellonVersion-debian `
                -t $Image`:debian `
                "debian"
}

if($Push){
    docker push $Image
}