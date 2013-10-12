## Install the required software
openldap-install:
  pkg.installed:
    - order: 1
    - names:
      - openldap-servers
      - openldap-clients
      - phpldapadmin

## Start the OpenLDAP service
slapd:
  service.running:
    - order: 2
    - enable: true

## Ensure Apache is running now but doesn't start at boot
httpd:
  service.running:
    - order: 3
    - enable: false
