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

FreeBSD 10.0-RELEASE and later needs CA root file.

<pre>
    # pkg install ca_root_nss
    # ln -s /usr/local/share/certs/ca-root-nss.crt /etc/ssl/cert.pem
</pre>

<pre>
    > fetch https://github.com/reallyenglish/bootstrap-freebsd-ami/tarball/master
    > tar zxf master
    > cd reallyenglish-bootstrap-freebsd-ami-*
    # make
</pre>

ec2-scripts-1.3 cannot enable swap. to work around the problem, define FIX_SWAP.

FIXME: remove the work around here when the bug is fixed in the upstream.

add extra disk storage
======================

launch an instance with extra disk. after boot:

<pre>
    # dmesg | grep xbd
    xbd0: 10240MB <Virtual Block Device> at device/vbd/768 on xenbusb_front0
    xbd0: attaching as ada0
    xbd1: 4090MB <Virtual Block Device> at device/vbd/51728 on xenbusb_front0
    xbd1: features: flush, write_barrier
    xbd1: synchronize cache commands enabled.
    xbd2: 32768MB <Virtual Block Device> at device/vbd/51744 on xenbusb_front0
    # gpart create -s GPT xbd2
    xbd2 created
    # gpart add -t freebsd-ufs xbd2
    xbd2p1 added
    # gpart show xbd2
    =>      34  67108797  xbd2  GPT  (32G)
            34  67108797     1  freebsd-ufs  (32G)
    # ls /dev/xbd2*
    /dev/xbd2   /dev/xbd2p1
    # newfs /dev/xbd2p1
        using 53 cylinder groups of 626.09MB, 20035 blks, 80256 inodes.
    super-block backups (for fsck -b #) at:
     192, 1282432, 2564672, 3846912, 5129152, 6411392, 7693632, 8975872, 10258112, 11540352, 12822592, 14104832, 15387072, 16669312, 17951552, 19233792,
    ...
    # mkdir /data
    # mount /dev/xbd2p1 /data
    # mount -p | grep xbd2
    /dev/xbd2p1     /data           ufs rw      2 2
    # mount -p | grep xbd2 >> /etc/fstab
</pre>
