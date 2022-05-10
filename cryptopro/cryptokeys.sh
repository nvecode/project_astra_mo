#!/bin/bash

keys=($(cat /etc/ansible/CryptoPRO/crypto_keys.txt))
hosts=($(awk '{print $1}' /etc/ansible/hosts.ini | sed '1d'))
for i in "${!hosts[@]}"; do
    if sshpass -p '123' ssh -o StrictHostKeyChecking=no client@${hosts[i]} 'sudo \
    /opt/cprocsp/sbin/amd64/cpconfig -license -set '${keys[i]}'' &> /dev/null
    then echo "Лицензия для хоста '${hosts[i]}' успешно установлена!"
    else echo "Ошибка при установке лицензии на хоста '${hosts[i]}'"
    echo -e "\n"
    fi
done
