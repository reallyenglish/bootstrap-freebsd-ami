bootstrap-freebsd-ami
=====================

bootstrapping scripts for FreeBSD AMI

check the latest AMI ID
=======================

the latest AMIs can be found at http://www.daemonology.net/freebsd-on-ec2/

* FreeBSD $x.$y-RELEASE For 64-bit "Windows" instances
* ap-northeast-1

booting base AMI
================

* go to [EC2 Dashboard]
* click [Launch Instance]
* in [Create a New Instance], select [Classic Wizard], click [Continue]
* click [Community AMIs] tab, enter the AMI ID in search field, select the AMI
* select [M1 Small] in [Instance Type], select [EC2 Classic] in [Launch into], click [Continue]
* in [Advanced Instance Options], just click [Continue]
* in [Storage Device Configuration], just click [Continue]
* assign NO tag, click [Continue]
* select YOUR Key Pairs, click [Continue]
* select default security group, click [Continue]
* review the configuration, click [Launch]
* take note of [Instance ID]
* filter the instance by the instance ID in [Instances], select the instance
* ssh to the instance. the hostname can be found in [Public DNS]. use "ec2-user" as login name

<pre>
    > ssh ec2-user@$HOSTNAME
</pre>

bootstrap the instance
======================

* download the reposiroty tar file
* untar the file
* run make

<pre>
    > fetch https://github.com/reallyenglish/bootstrap-freebsd-ami/tarball/master
    > tar zxf master
    > cd reallyenglish-bootstrap-freebsd-ami-*
    # make
</pre>

ec2-scripts-1.3 cannot enable swap. to work around the problem, define FIX_SWAP.

FIXME: remove the wrok around here when the bug is fixed in the upstream.
