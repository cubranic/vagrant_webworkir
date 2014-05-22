# NOTE: expects to run as the root user

## packages
apt-get -qq update
#apt-get -qq upgrade

apt-get -qq install \
        apache2 \
        apache2-mpm-prefork  \
        apache2.2-common  \
        libapreq2  \
        dvipng  \
        gcc  \
        perl  \
        perl-modules  \
        libapache2-request-perl  \
        git  \
        libdatetime-perl  \
        libdbi-perl  \
        libdbd-mysql-perl  \
        libemail-address-perl  \
        libexception-class-perl  \
        libextutils-xsbuilder-perl  \
        libgd-gd2-perl  \
        liblocale-maketext-lexicon-perl  \
        libmime-tools-perl  \
        libnet-ip-perl  \
        libnet-ldap-perl \
        libnet-oauth-perl  \
        libossp-uuid-perl  \
        libpadwalker-perl  \
        libphp-serialization-perl  \
        libsoap-lite-perl  \
        libsql-abstract-perl  \
        libstring-shellquote-perl  \
        libtimedate-perl  \
        libuuid-tiny-perl  \
        libxml-parser-perl  \
        libxml-writer-perl  \
        libpod-wsdl-perl  \
        libjson-perl  \
        libtext-csv-perl  \
        libhtml-scrubber-perl  \
        make  \
        netpbm  \
        openssh-server  \
        preview-latex-style  \
        subversion  \
        texlive  \
        unzip \
        liblocal-lib-perl

## Additional Perl packages from CPAN
apt-get -qq install cpanminus
cpanm --self-upgrade
cpanm Term::ReadPassword XML::Parser::EasyTree HTML::Template Iterator Iterator::Util Mail::Sender JSON File::Find::Rule 
mkdir /usr/include/apache2
cpanm Apache2::SOAP
a2enmod apreq
apache2ctl restart

## MySql
debconf-set-selections <<< 'mysql-server-<version> mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server-<version> mysql-server/root_password_again password root'
apt-get -y install mysql-server

perl /vagrant/ww_install.pl

## Rserve Perl connector
cpanm Statistics::RserveClient
# RserveClient.pl is saved in https://gist.github.com/djun-kim/5130048
wget -q -O /opt/webwork/pg/macros/RserveClient.pl https://gist.githubusercontent.com/djun-kim/5130048/raw/a2f11154d43ec3f92d06e4828fee46ca445504a0/gistfile1.pl

## Add RserveClient modules to the default config
cat >> /opt/webwork/webwork2/conf/localOverrides.conf <<'EOF'
push @{$pg{modules}}, [qw(Statistics::RserveClient::Connection)];
1;
EOF

## RserveClient always opens the debug log file for writing, and for
## some reason this is owned by root and not writeable by the www-data
## user to whom the WWk process belongs
touch /tmp/rserve-debug.log
chgrp www-data /tmp/rserve-debug.log
chmod 664 /tmp/rserve-debug.log

## Rserve server
echo "deb http://cran.stat.sfu.ca/bin/linux/ubuntu precise/" > /etc/apt/sources.list.d/r.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
apt-get update
apt-get -qq install r-base-dev

Rscript -e 'install.packages(c("Rserve", "RSclient"), repo="http://cran.stat.sfu.ca")'

R CMD Rserve --quiet --no-save
