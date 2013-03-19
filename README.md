bootstrap-freebsd-ami
=====================

bootstrapping scripts for FreeBSD AMI

* download the reposiroty tar file
* untar the file
* run make

<pre>
    > fetch https://github.com/reallyenglish/bootstrap-freebsd-ami/tarball/master
    > tar zxf master
    > cd reallyenglish-bootstrap-freebsd-ami-*
    # make
</pre>

ec2-scripts-1.3 cannot enable swap. to work around the problem, define FIX_SWAP
