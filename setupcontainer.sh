#!/bin/sh

(cd /lib/systemd/system/sysinit.target.wants/;
for i in *; do [ $i ==  systemd-tmpfiles-setup.service ] || rm -f $i; done);
rm -f /lib/systemd/system/multi-user.target.wants/*
rm -f /etc/systemd/system/*.wants/*
rm -f /lib/systemd/system/local-fs.target.wants/*
rm -f /lib/systemd/system/sockets.target.wants/*udev*
rm -f /lib/systemd/system/sockets.target.wants/*initctl*
rm -f /lib/systemd/system/basic.target.wants/*
rm -f /lib/systemd/system/anaconda.target.wants/*

systemctl enable sshd
systemctl enable xrdp
systemctl disable kdump

cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

rm /etc/localtime
(cd /etc; ln -s /usr/share/zoneinfo/Japan  localtime)

rm -f /etc/xdg/autostart/xfce-polkit.desktop
echo '%wheel        ALL=(ALL)       NOPASSWD: ALL' >> /etc/sudoers

cat <<EOF > /etc/locale.conf
LANG=en_US.UTF-8
EOF

cat <<EOF > /etc/supervisord.d/xrdp.ini
[program:xrdp-sesman]
command=/sbin/xrdp-sesman -n
redirect_stderr=true
stdout_logfile=/var/log/xrdp-sesman.log

[program:xrdp]
command=/sbin/xrdp -n
redirect_stderr=true
stdout_logfile=/var/log/xrdp.log
EOF
