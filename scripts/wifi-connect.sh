#!/bin/bash

function wificonnect () {
    IFS=$'\n'

    wifi_list=($(nmcli device wifi list | sed -n '1!p' | cut -b 9- | awk -F" {2,}" '{print $2}'))
    existing_wifi_connections=($(nmcli con show | grep wifi | awk -F" {2,}" '{print $1}'))

    if [[ ${#wifi_list[@]} -eq 0 ]]; then
        echo "No Wi-Fi networks available."
        return
    fi
    for ((i=0; i<${#wifi_list[@]}; i++)); do
        echo "$((i+1)) ${wifi_list[i]}"
    done

    read "choice?Select a Wi-Fi network (enter the corresponding number): "
        
    if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 1 && "$choice" -le "${#wifi_list[@]}" ]]; then
        selected_wifi="${wifi_list[$((choice-1))]}"
        if [[ "${existing_wifi_connections[*]}" =~ "$selected_wifi" ]]; then
            echo "WiFi network already exists. Connecting..."
            nmcli device wifi connect "$selected_wifi"
        else
            read -s "password?Enter your password: " 
            nmcli device wifi connect "$selected_wifi" password $password
        fi
    else
        echo "Invalid input. Please enter a number corresponding to the Wi-Fi network."
    fi
}


