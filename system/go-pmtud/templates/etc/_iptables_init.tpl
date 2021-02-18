#!/usr/bin/env bash

# make sure to update iptables-stop script to keep commands aligned

nflog_group=( {{ .Values.iptables.nflogGroup }} )
INTERFACE=$(/sbin/ip route | grep -v cbr | awk '/default/ { print $5 }')

echo "Outgoing inteface is ${INTERFACE}"

# disable rp_filter
sysctl -w net.ipv4.conf.eno1.rp_filter=0
sysctl -w net.ipv4.conf.enp1s0f0.rp_filter=0
sysctl -w net.ipv4.conf.all.rp_filter=0

if iptables -t raw -C PREROUTING -i ${INTERFACE} -p icmp -m icmp --icmp-type 3/4 --j NFLOG --nflog-group ${nflog_group} ; then
  echo "Rule for redirecting ICMP frag-needed packets to nflog-group ${nflog_group} already present - skipping"
else
  echo "Rule for redirecting ICMP frag-needed packets to nflog-group ${nflog_group} not present - creating rule"
  iptables -t raw -I PREROUTING -i ${INTERFACE} -p icmp -m icmp --icmp-type 3/4 --j NFLOG --nflog-group ${nflog_group}
fi
