#!/bin/bash
function wificonnect () {
IFS=$'\n'
select wifi in $(nmcli device wifi list | sed -n '1!p' |cut -b 9-|awk -F" {2,}" '{print $2}') ;
  # read -s -p is not compatible with zsh
do  read -s "password?Enter Your password: ";
nmcli device wifi connect $wifi password $password;
break ; 
done
}
