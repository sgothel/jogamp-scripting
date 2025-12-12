# Apache2: Installing suexec + fcgid

## /etc/php/8.2/cgi/php.ini or /etc/php/8.4/cgi/php.ini

Temp Folder:
```
sys_temp_dir = "/var/tmp"
upload_tmp_dir = "/var/tmp"
upload_max_filesize = 256M
post_max_size = 256M
```

Enable opcache:
```
zend_extension=opcache

[opcache]
; Determines if Zend OPCache is enabled
opcache.enable=1
```

See php8.2.ini and php8.4.ini

## suexec
```
apt-get install apache2-suexec-custom

groupadd webrunner
useradd -s /bin/false -d /srv/www -g webrunner webrunner

# adding webrunner group to apache2's www-data UID allows access 
# to chown -R webrunner:webrunner /srv/www/<bla>
usermod -a -G webrunner www-data
```

/etc/apache2/suexec/www-data
```
/srv/www
public_html/cgi-bin
```

cp -a /etc/apache2/suexec/www-data /etc/apache2/suexec/webrunner

## php8.2-cgi + libapache2-mod-fcgid
### Fix installation
```
apt-get install php8.2-cgi libapache2-mod-fcgid libfcgi-perl

a2dismod php8.2

a2enmod rewrite
a2enmod suexec
a2enmod include
a2enmod fcgid 

cd /etc/apache2/mods-enabled/
rm php7.0.*

dpkg -P libapache2-mod-php8.2
```

### Prepare wrapper scripts
```
mkdir /srv/www/scripts
```

Add `/srv/www/scripts/php8\_2-wrapper`
```
#!/bin/sh
PHPRC=/etc/php/8.2/cgi
export PHPRC
export PHP_FCGI_MAX_REQUESTS=5000
export PHP_FCGI_CHILDREN=8
exec /usr/lib/cgi-bin/php8.2
```

Fix ownership
```
chmod 755 /srv/www/scripts/php8.2-wrapper
chown -R webrunner:webrunner /srv/www/scripts
```

/etc/apache2/sites-enabled/0xy-z.conf
```
<VirtualHost *:80>
    SuexecUserGroup webrunner webrunner

    <Directory /srv/www/jordan>
        Options +Indexes +ExecCGI -MultiViews +SymLinksIfOwnerMatch

        AddHandler fcgid-script .php
        FcgidWrapper /srv/www/scripts/php8_2-wrapper .php
    </Directory>
```

Restart either
```
systemctl restart apache2
```
or
```
/etc/init.d/apache2 restart
```

