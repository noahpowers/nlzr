function https-website() {
	read -p 'What is your URL (www.example.com)?  ' -r webaddr
	service apache2 stop > /dev/null
	a2enmod ssl > /dev/null
	cd /etc/apache2/sites-enabled/
	a2dissite 000-default.conf > /dev/null 2>&1
	a2dissite default-ssl.conf > /dev/null 2>&1
	if [ ! -f /etc/apache2/sites-available/000-default.conf-bkup ];
		then printf "[ ] backing-up 000-default.conf"; 
		cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf-bkup;
		else echo "[ / ] 000-default.conf already backed up at some point"; 
	fi
	if [ ! -f /etc/apache2/sites-available/000-default.conf-bkup ];
		then printf "[ ] backing-up default-ssl.conf"; 
		cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf-bkup; 
	else echo "[ / ] default-ssl.conf already backed up at some point"
	fi

    cat <<-EOF > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    <Directory "/var/www/html">
        AllowOverride All
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
    echo "[ + ]  Writing SSL config file"
    cat <<-EOF > /etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        SSLEngine on
        SSLCertificateFile /etc/letsencrypt/live/${webaddr}/cert.pem
        SSLCertificateKeyFile /etc/letsencrypt/live/${webaddr}/privkey.pem
        SSLCertificateChainFile /etc/letsencrypt/live/${webaddr}/chain.pem
        <FilesMatch "\.(cgi|shtml|phtml|php)$">
            SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
            SSLOptions +StdEnvVars
        </Directory>
    </VirtualHost>
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOF
    echo "[ + ]  Creating HTACCESS file with REWRITE rules"
    cat <<-EOF > /var/www/html/.htaccess
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301] 
</IfModule>
EOF
    cd /etc/apache2/sites-available/
    echo "[ + ]  Restarting Apache2"
    service apache2 start > /dev/null
    echo "[ + ]  Enabling HTTP-S site"
    a2ensite default-ssl.conf > /dev/null
    echo "[ + ]  Enabling HTTP site"
    a2ensite 000-default.conf > /dev/null
    echo "[ + ]  Restarting Apache2"
    service apache2 reload > /dev/null
    sleep 3
    if [ $(lsof -nPi | grep -i apache | grep -c ":443 (LISTEN)") -ge 1 ]; 
    	then echo '[+] Apache2 SSL is running!'
    fi
}

$@https-website
