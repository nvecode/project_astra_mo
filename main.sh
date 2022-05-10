#!/bin/bash

echo -e "###############################################################################\n
Главный файл запуска скриптов YAML!\n
Список команд для исполнения на удалённых хостах:\n
1. Подключение сетевой папки по протоколу «SMB».
2. Установка программы для удалённого доступа «АССИСТЕНТ».
3. Установка криптопровайдера «КриптоПРО» и, при необходимости, привязка ключа.
4. Настройка межсетевого экрана.
5. Установка программного обеспечения «КСАМУ» для решения лечебно-профилактических задач.
6. Установка и настройка агента мониторинга Zabbix."

read -p "Для нужного скрипта необходимо ввести соответствующую цифру: " number

case $number in

    "1" | "1.")
        read -p "Путь до директории, куда будет монтироваться удалённый ресурс (в формате /mnt/share): " smb_local_dir &&
        read -p "IP-адрес ресурса, который необходимо примонтировать (в формате //X.X.X.X/change): " smb_remote_dir &&
        read -p "Пользователь для подключения к удалённому ресурсу: " smb_user &&
        read -p "Пароль пользователя: " smb_pass &&
        sed -i 's|smb_local_path:.*|smb_local_path: '$smb_local_dir'|;s|smb_remote_path:.*|smb_remote_path: '$smb_remote_dir'|;s|smb_username:.*|smb_username: '$smb_user'|;s|smb_password:.*|smb_password: '$smb_pass'|' playbooks/smb.yml
        ansible-playbook -i hosts.ini playbooks/smb.yml && echo -e "Команда выполнена успешно!\n" || echo -e "Произошла ошибка!\n"
        ;;

    "2" | "2.")
        ansible-playbook -i hosts.ini playbooks/asistent.yml && echo -e "Команда выполнена успешно!\n" || echo -e "Произошла ошибка!\n"
        ;;

    "3" | "3.")
        read -p "Установку КриптоПРО выполнить с дальнейшей установкой лицензии (Да/Нет)? " keys_q
        case $keys_q in
            "Да" | "да")
                read -p "Лицензии внесены в файл по пути crypropro/crypto_keys.txt (Да/Нет)? " keys_w
                    case $keys_w in
                        "Да" | "да")
                            ansible-playbook -i hosts.ini playbooks/crypropro.yml && bash crypropro/cryptokeys.sh &&
                            echo -e "Команда выполнена успешно!\n" || echo -e "Произошла ошибка!\n"
                            ;;
                        "Нет" | "нет")
                            echo "Заполните данные по лицензиям в файл по пути crypropro/crypto_keys.txt. Каждую лицензию указывать с новой строки. Перезапустите скрипт!"
                            ;;
                    esac
                    ;;
            "Нет" | "нет")
                ansible-playbook -i hosts.ini playbooks/cryptopro.yml &&  echo -e "Команда выполнена успешно!\n" || echo -e "Произошла ошибка!\n"
                ;;
            *)
                echo "Неизвестный параметр. Запустите скрипт заново!"
                ;;
        esac
        ;;

    "4" | "4.")
        read -p "Введите IP-адрес или сеть в формате Х.Х.Х.Х/24 для разрешения на подключения по SSH: " f_allow &&
        sed -i 's|f_src_net:.*|f_src_net: '$f_allow'|' playbooks/iptables.yml &&
        ansible-playbook -i hosts.ini playbooks/iptables.yml && echo -e "Команда выполнена успешно!\n" || echo -e "Произошла ошибка!\n"
        ;;

    "5" | "5.")
        ansible-playbook -i hosts.ini playbooks/ksamu.yml && bash /etc/ansible/ksamu/start_ksamu_install.sh && echo -e "Команда выполнена успешно!\n" || echo -e "Произошла ошибка!\n"
        ;;

    "6" | "6.")
        read -p "Введите IP-адрес сервера Zabbix: " server_zabbix &&
        sed -i 's/zabbix_server:.*/zabbix_server: '$server_zabbix'/' playbooks/zabbix.yml &&
        ansible-playbook -i hosts.ini playbooks/zabbix.yml && echo -e "Команда выполнена успешно!\n" || echo -e "Произошла ошибка!\n"
        ;;

    * )
        echo "Неизвестный параметр. Запустите скрипт заново!"
        ;;
esac