all:	_copy_files_done

_copy_files_done:	copy_files
	touch ${.TARGET}

copy_files:
	install -o root -g wheel -m 600 pf.conf /etc/
	install -o root -g wheel -m 755 pf_reload /etc/rc.d/
	cat sysctl.conf >> /etc/sysctl.conf
	cat rc.conf >> /etc/rc.conf

clean:
	rm *_done
