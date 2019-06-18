#!/bin/bash
LOG=/var/log/syn_ddos.log
echo -e "======\nStart script in `date +%F_%T`\n======" >> $LOG
ip_ban () {
    IP=$1
    IPTABLES=`which iptables`
    $IPTABLES -I INPUT -s $IP -j DROP && echo -e "ban $IP - `date +%F_%T`" >> $LOG
}
check_ddos_syn () {
    ADDR_LIST=`netstat -na | grep ':80\|:443' | grep SYN | awk '{print$5}' | cut -d':' -f1 | sort | uniq`
    for ADDR in $ADDR_LIST; do
        ip_ban "$ADDR"
    done
}
TIME_SLEEP='5'
while :; do
    sheck_ddos_syn
    sleep $TIME_SLEEP
done
