#!/bin/bash

##
## Warning: This script has only been tested on CentOS 6.4
##          and SELinux was disabled.
##

##
## Use this script like so: ./init.sh [tutorial name]
## As an example, for http://ctrlaltlinux.com/2013/10/09/setting-up-openldap/ use:
## ./init.sh setting-up-openldap
##

if [ -z $TUTORIAL ]
then
  echo "You must set the TUTORIAL environment variable"
  echo "Example: TUTORIAL=setting-up-openldap ./init.sh"
  exit -1
fi

## EPEL is required for SaltStack and other software used during the tutorials
yum install -y http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

## Salt is used to configure the server 
yum install -y salt-minion git

## Clone a copy of the tutorial configuration files
git clone https://github.com/ctrlaltlinux/tutorials /root/ctrlaltlinux

## Finally, run salt to apply the server configuration
salt-call --local --config-dir /root/ctrlaltlinux/$TUTORIAL/ state.highstate
