#!/bin/bash
set -e
PS4="> ${0##*/}: "
set -x

zfs_gate_dir="$(readlink -f ${BASH_SOURCE})"
zfs_gate_dir="${zfs_gate_dir%/*}"
cgi_bin_dir="$zfs_gate_dir/cgi-bin"
service_dir="$zfs_gate_dir/service"
etc_dir="$zfs_gate_dir/etc"
bin_dir="$zfs_gate_dir/bin"
systemd_unit_dir="$(grep systemdsystemunitdir= /usr/share/pkgconfig/systemd.pc)"
systemd_unit_dir="${systemd_unit_dir#*=}"
www_dir="/var/www"

# check availability of busybox
type busybox &>/dev/null

# check availability of busybox httpd
[[ $(busybox httpd -e abc 2>/dev/null) == "abc" ]]

if [[ "$(readlink -f $www_dir/cgi-bin 2>/dev/null)" != "$cgi_bin_dir" ]]; then
    mkdir "$www_dir"
    ln -s "$cgi_bin_dir" "$www_dir"
fi

if [[ ! -f /etc/zfs-gate.conf ]]; then
    cp "$etc_dir/zfs-gate.conf" /etc
fi

sed -e "s!@ZFS_GATE_DIR@!$zfs_gate_dir!" \
       "$service_dir/zfs-gate.service.in" \
       >"$systemd_unit_dir/zfs-gate.service"
systemctl daemon-reload
systemctl enable zfs-gate
