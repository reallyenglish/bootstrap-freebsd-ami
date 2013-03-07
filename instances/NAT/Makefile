all:	_copy_files_done

_copy_files_done:	copy_files
	touch ${.TARGET}

copy_files:
	cp pf.conf /etc/
	cat sysctl.conf >> /etc/sysctl.conf
	cat rc.conf >> /etc/rc.conf

clean:
	rm *_done
