#!/bin/bash

file001=/etc/dnf/automatic.conf

### q run upate
###
###
u_dnf_update=y
printf "\n\n***********************************************\n\n"
read -p "Run dnf update [y/n]: " -ei $u_dnf_update u_dnf_update

#printf "\n\n***********************************************\n\nRun dnf update [y/n]: "
#if [ "$u_dnf_update" = "" ]; then
#    read u_dnf_update
#fi

if [ "$u_dnf_update" = "y" ]; then
    printf "\n"
    date +%s >/tmp/time.log
    dnf clean all
    dnf -y update
    date +%s >>/tmp/time.log
fi

### install
###
###
printf "\n\n***********************************************\n\nInstall apps via dnf [y/n]: "
if [ "$u_dnf" = "" ]; then
    read u_dnf
fi

if [ "$u_dnf" = "y" ]; then

    ### perltidy not found on fucking RHEL - "an dnf error not found" installiert kein einziges Paket !!!
    ### package errors : webalizer, perl-Net-LibIDN not available in ROCKY9 - 13.8.2022
    ### package conflict : opendkim opendkim-tools in ROCKY9 - 13.8.2022
    dnf -y install epel-release yum-utils
    dnf -y install chrony httpd mysql $db_server php php-mysqlnd php-intl php-json php-ldap php-pecl-zip php-process net-tools which certbot createrepo bind-utils whois postfix postfix-mysql figlet mod_fcgid mod_security mod_security_crs vsftpd php-mbstring dovecot dovecot-mysql rsyslog iptraf-ng dnf-automatic perl-DBI perl-DBD-MySQL perl-Encode-Detect perl-JSON gd gd-devel php-gd perl-Net-SSLeay python3-certbot-apache spamassassin tcp_wrappers php-soap php-xml php-gmp mod_http2 at conntrack-tools rsync tar wget lftp ncftp unzip git nodejs quota jq perl-Net-LibIDN2 libidn libidn2 lsof htop iftop glibc-langpack-de

    ### Solange wir die Signatur nicht ändern können, müssen wir lokal installieren
    ###
    ###
    rpm -Uvh --nosignature $u_path/files/rpm/pam_mysql-0.8.1-0.6.el8.x86_64.rpm

    ### setze automatic dnf
    ### https://www.tecmint.com/setup-automatic-updates-for-centos-8/
    if [ -f "$file001" ]; then
        sed -i 's/^upgrade_type = default/upgrade_type = security/' $file001
        sed -i 's/^apply_updates = no/apply_updates = yes/' $file001
        sed -i 's/^emit_via = stdio/emit_via = motd/' $file001

        systemctl enable --now dnf-automatic.timer
    fi

fi
