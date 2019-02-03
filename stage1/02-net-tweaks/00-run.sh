#!/bin/bash -e

install -m 644 files/ipv6.conf "${ROOTFS_DIR}/etc/modprobe.d/ipv6.conf"
echo "${PI_HOSTNAME}" > "${ROOTFS_DIR}/etc/hostname"
if [ "${PI_HOSTNAME}" != "raspberrypi" ]
then
	echo "127.0.0.1		${PI_HOSTNAME}" >> "${ROOTFS_DIR}/etc/hosts"
fi

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"
