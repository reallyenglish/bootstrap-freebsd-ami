AWK?=	/usr/bin/awk
SYSCTL?=	/sbin/sysctl
SRC_BASE?=	/usr/src

# the size of swap in MB if available.
# to enable swap, choose an instance type WITH ephemeral disk storage MORE THAN
# 4GB. note that small instances do not have ephemeral disk. "4000" was choosen
# because m3.medium has 4GB of ephemeral disk but "4096" does not work here.
# if you specify "AUTO" here, the size of swap is automatically caluculated
# (but only if ephemeral disk is large enough to create swap on it).
SWAP_SIZE?=	4000

# Get __FreeBSD_version (obtained from bsd.port.mk)
.if !defined(OSVERSION)
.if exists(/usr/include/sys/param.h)
OSVERSION!= ${AWK} '/^\#define[[:blank:]]__FreeBSD_version/ {print $$3}' < /usr/include/sys/param.h
.elif exists(${SRC_BASE}/sys/sys/param.h)
OSVERSION!= ${AWK} '/^\#define[[:blank:]]__FreeBSD_version/ {print $$3}' < ${SRC_BASE}/sys/sys/param.h
.else
OSVERSION!= ${SYSCTL} -n kern.osreldate
.endif
.endif

 all:	clean
	chpass -s /bin/sh root
	echo panicmail_enable=\"NO\" >> /etc/rc.conf
	echo ec2_bootmail_enable=\"NO\" >> /etc/rc.conf
	echo ec2_bootmail_enable=\"NO\" >> /etc/rc.conf
	echo ec2_ephemeralswap_size=\"SWAP_SIZE\" >> /etc/rc.conf
.if ${OSVERSION} >= 1000000
	touch /firstboot
.else
	touch /root/firstboot
.endif
	cp ec2_user_data /etc/rc.d/ec2_user_data
	chown root:wheel /etc/rc.d/ec2_user_data
	chmod 755 /etc/rc.d/ec2_user_data
.if defined(FIX_SWAP)
.if ${OSVERSION} >= 1000000
	# swap bug is fixed on 10.0-RELEASE
.else
	(cd /usr/local/etc/rc.d && patch < ${.CURDIR}/patch-ec2_ephemeralswap)
.endif
.endif
.if ${OSVERSION} >= 901000
	chpass -s /bin/sh ec2-user
	pw usermod -u 0 -n ec2-user
	chown -R root:wheel /home/ec2-user
.endif
 
 clean:
	rm -f /root/.ssh/authorized_keys
	rm -f /root/.history
.if ${OSVERSION} >= 901000
	rm -f /home/ec2-user/.ssh/authorized_keys
	rm -f /home/ec2-user/.history
	echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
.endif
	rm -f /etc/ssh/ssh_host_*
