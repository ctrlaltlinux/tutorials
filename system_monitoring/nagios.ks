#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Firewall configuration
firewall --enabled --service=ssh
# Use CDROM installation media
cdrom
repo --name="CentOS" --baseurl=cdrom:sr0 --cost=100
# Network information
network  --bootproto=dhcp --device=eth0
# Root password
rootpw --iscrypted $1$2.H2GU/v$WWwZfD1iPFk6JimnEZqZ91
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use text mode install
text
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# SELinux configuration
selinux --enforcing
# Installation logging level
logging --level=info
# Reboot after installation
reboot
# System timezone
timezone  Australia/Brisbane
# System bootloader configuration
bootloader --append="crashkernel=auto rhgb quiet" --location=mbr --driveorder="vda"
# Partition clearing information
clearpart --all  
# Disk partitioning information
part /boot --fstype="ext4" --size=1024
part swap --fstype="swap" --size=1024
part / --fstype="ext4" --grow --size=1

%post
yum install http://mirror.optus.net/epel/6/i386/epel-release-6-7.noarch.rpm
yum install puppet
%end

%packages --nobase
@core

%end
