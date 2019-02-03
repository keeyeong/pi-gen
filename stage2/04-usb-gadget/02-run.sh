#!/bin/bash -e

if [ "${GADGET_ETHERNET}" = "1" ]; then
	echo 'dtoverlay=dwc2' >> "${ROOTFS_DIR}/boot/config.txt"
	sed -i "s/rootwait/rootwait\ modules-load=dwc2\ /" "${ROOTFS_DIR}/boot/cmdline.txt"
fi
if [ "${GADGET_ETHERNET}" = "1" ]; then
	sed -i "s/modules-load=dwc2/modules-load=dwc2,g_ether\ g_ether.host_addr=00:22:82:ff:ff:42 g_ether.dev_addr=00:22:82:ff:ff:82/" "${ROOTFS_DIR}/boot/cmdline.txt"
	install -m 755 files/interfaces		"${ROOTFS_DIR}/etc/network/interfaces"
	install -m 755 files/iptables.ipv4.nat	"${ROOTFS_DIR}/etc/iptables.ipv4.nat"
	install -m 755 files/dhcpd.conf		"${ROOTFS_DIR}/etc/dhcp/dhcpd.conf"
	install -m 755 files/isc-dhcp-server	"${ROOTFS_DIR}/etc/default/isc-dhcp-server"
	echo "net.ipv4.ip_forward=1" >> 	"${ROOTFS_DIR}/etc/sysctl.conf"
	# Restrict zeroconf to only the USB interface device
	sed -i "s/#allow-interfaces=eth0/allow-interfaces=usb0/" "${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf"
	# Restrict SSH to only from the USB interface IP
	sed -i "s/#ListenAddress 0.0.0.0/ListenAddress 172.16.0.1/" "${ROOTFS_DIR}/etc/ssh/sshd_config"
fi
