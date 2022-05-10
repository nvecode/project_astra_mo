#!/bin/bash

hosts=($(awk '{print $1}' /etc/ansible/hosts.ini | sed '1d'))
for i in $hosts
do sshpass -p '123' ssh -o StrictHostKeyChecking=no client@$i 'cd /home/client/distrib_ksamu_astra_1.6_update/; ./install.sh'
done
