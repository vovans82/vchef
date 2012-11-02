#!/bin/bash
#####################################################
# This script is working around a routing issue,    #
# Where traffic to the WS vip from WS is going out  #
# of 					            #
# the public NIC eth0 instead of the private eth1.  #
# Rackspace have proivded a map of network address  #
# to GW map, Which we use to install static routes  #
# for 192.168.100.0/24 and 192.168.99.0/24 to go    #
# out of the private network                        #
#####################################################

gw_file=/usr/local/bin/gw.txt
ipc=`which ipcalc`
my_ip=`cat /etc/sysconfig/network-scripts/ifcfg-eth1 |grep -i ipaddr |awk -F = '{print $2}'`
my_netmask=`ifconfig |grep $my_ip |grep -i mask |awk -F : '{print$4}'`
my_network=`ipcalc -4 $my_ip $my_netmask -n | sed 's\=\ \g' | awk '{print $2}' `
GW=`cat $gw_file  | grep $my_network   | awk '{print $2}'`
GW=`echo $GW | perl -ne 's/[\n\r]//g; print'`

ws_net1=`grep "192.168.99.0/24 via" /etc/sysconfig/network-scripts/route-eth1 |wc -l`
ws_net2=`grep "192.168.100.0/24 via" /etc/sysconfig/network-scripts/route-eth1 | wc -l`

if [ $ws_net1 -eq 0 ] && [ "$GW" != '' ] ; then
echo 192.168.99.0/24 via $GW dev eth1 >> /etc/sysconfig/network-scripts/route-eth1
fi

if [ $ws_net2 -eq 0 ] && [ "$GW" != '' ] ; then
echo 192.168.100.0/24 via $GW dev eth1 >> /etc/sysconfig/network-scripts/route-eth1
fi

cmd1=`route | grep 192.168.99.0 | wc -l`
cmd2=`route | grep 192.168.100.0 | wc -l`

if [ $cmd1 -eq 0 ] && [ "$GW" != '' ]; then
route del -net 192.168.99.0/24
route add -net 192.168.99.0/24 gw $GW
fi
if [ $cmd2 -eq 0 ] && [ "$GW" != '' ]; then
route del -net 192.168.100.0/24
route add -net 192.168.100.0/24 gw $GW
fi
