{% set basedn = "dc=ctrlaltlinux,dc=net" %}
{% set pwd = "secret" %}
{% set pwdhash = "{SSHA}EwdxgG99WRZhSS7fmWfHfJcDP2Hc696J" %}

## Install the required software
install packages:
  pkg.installed:
    - order: 1
    - names:
      - openldap-servers
      - openldap-clients
      - phpldapadmin

## Change the Base DN in slapd configuration files
replace base dn in monitor.ldif:
  file.sed:
    - order: 2
    - name: /etc/openldap/slapd.d/cn=config/olcDatabase={1}monitor.ldif
    - before: dc=my-domain,dc=com
    - after: {{ basedn }}
    - flags: g

replace base dn in bdb.ldif:
  file.sed:
    - order: 3
    - name: /etc/openldap/slapd.d/cn=config/olcDatabase={2}bdb.ldif
    - before: dc=my-domain,dc=com
    - after: {{ basedn }}
    - flags: g

## Set the olcRootPW entry
set root password in config.ldif:
  file.append:
    - order: 4
    - name: /etc/openldap/slapd.d/cn=config/olcDatabase={0}config.ldif
    - text: "olcRootPW: {{ pwdhash }}"

set root password in bdb.ldif:
  file.append:
    - order: 5
    - name: /etc/openldap/slapd.d/cn=config/olcDatabase={2}bdb.ldif
    - text: "olcRootPW: {{ pwdhash }}"

## Comment out the line that appends uid= to the login name
modify phpldapadmin config:
  file.comment:
    - order: 6
    - name: /etc/phpldapadmin/config.php
    - regex: ^\$servers\->setValue\('login','attr','uid'\);
    - char: //

## Start the OpenLDAP service
configure slapd service:
  service.running:
    - order: 7
    - name: slapd
    - enable: true

## Ensure Apache should be running now but shouldn't start at boot
configure apache service:
  service.running:
    - order: 8
    - name: httpd
    - enable: false

## Import some test data in to openldap
import ldap test data:
  cmd.run:
    - order: 9
    - name: ldapadd -x -D cn=manager,{{ basedn }} -w {{ pwd }} -f /root/ctrlaltlinux/setting-up-openldap/testdata.ldif
    - unless: 'ldapsearch -x -D cn=manager,{{ basedn }} -w {{ pwd }} -s base -b "dc=ctrlaltlinux,dc=net" | grep "objectClass: top"'
