 all:	clean
	chpass -s /bin/sh root
	echo panicmail_enable=\"NO\" >> /etc/rc.conf
	echo ec2_bootmail_enable=\"NO\" >> /etc/rc.conf
	touch /root/firstboot
	cp ec2_user_data /etc/rc.d/ec2_user_data
	chown root:wheel /etc/rc.d/ec2_user_data
	chmod 755 /etc/rc.d/ec2_user_data
 
 clean:
	rm -f /etc/ssh/ssh_host_*
	rm -f /root/.ssh/authorized_keys
	rm -f /root/.history
