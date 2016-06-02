Overview
====
zfs-gate provides some web API that you can used to list, create,
destroy, freeze and clone zvols and exposes these block devices through
iSCSI automatically.

How to install
====
Install dependencies
```
$ apt-get install debian-zfs targetcli busybox
```

If you are not familiar with zfs, refer to the page below
https://github.com/zfsonlinux/zfs/wiki/Getting-Started

Install zfs-gate
```
$ sudo -i
# git clone https://github.com/x-deepin/zfs-gate.git
# cd zfs-gate
# ./install.sh
```

Configure zfs-gate
====
You need to tell zfs-gate where to create zvols through the config file. For
example, if your zpool is named rpool, and the dataset you will used to put
all zvols is named images, then the default config is good enough
```
# /etc/zfs-gate.conf
# the zfs dataset we can create all zvols in it
IMAGES_DATASET='rpool/images'

# the iSCSI target IQN prefix
TARGET_IQN_PREFIX='iqn.2016-05.com.deepin:images'
```

Change the listening IP:PORT of httpd
====
By default, zfs-gate runs a httpd and listen on 127.0.0.1:80, you can override
this by the systemd drop-in file, for example
```
# mkdir /etc/systemd/system/zfs-gate.service.d
# cat <<END >/etc/systemd/system/zfs-gate.service.d/listen-all.conf
[Service]
ExecStart=
ExecStart=/bin/busybox httpd -f \\
    -p 0.0.0.0 \\
    -h /var/www \\
    -vvvv
END
```
