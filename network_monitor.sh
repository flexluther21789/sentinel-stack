#!/bin/bash
# network_monitor.sh - live network monitor using nmap

# Files to store previous scan and vendor cache
PREV_SCAN="/tmp/prev_scan.txt"
MAC_CACHE="/tmp/mac_cache.txt"

# Ensure files exist
touch $PREV_SCAN
touch $MAC_CACHE

# Function to get vendor for MAC
get_vendor() {
    local mac="$1"
    # Check cache first
    vendor=$(grep -i "^$mac " $MAC_CACHE | awk '{print $2}')
    if [ -n "$vendor" ]; then
        echo "$vendor"
        return
    fi

    # API call with throttling
    sleep 1
    response=$(curl -s "https://api.macvendors.com/$mac")
    if [ -n "$response" ]; then
        echo "$mac $response" >> $MAC_CACHE
        echo "$response"
    else
        echo "Unknown"
    fi
}

# Main loop
while true; do
    # Scan network with nmap
    nmap_output=$(sudo nmap -sn 192.168.2.0/24)

    # Prepare current scan
    current_scan=""

    ip=""
    mac=""
    vendor=""

    while IFS= read -r line; do
ip=$(echo "$line" | awk '{print $1}')
mac=$(echo "$line" | awk '{print $2}')
if [ -z "$ip" ] || [ -z "$mac" ]; then continue; fi
        if [[ $line =~ Nmap\ scan\ report\ for\ ([0-9.]+) ]]; then
            ip="${BASH_REMATCH[1]}"
        elif [[ $line =~ MAC\ Address:\ ([0-9A-F:]+)\ \((.*)\) ]]; then
            mac="${BASH_REMATCH[1]}"
            vendor="${BASH_REMATCH[2]}"
            current_scan+="$ip $mac $vendor"$'\n'
        fi
    done <<< "$nmap_output"

    # Detect left devices
    if [ -f "$PREV_SCAN" ]; then
        while IFS= read -r line; do
ip=$(echo "$line" | awk '{print $1}')
mac=$(echo "$line" | awk '{print $2}')
if [ -z "$ip" ] || [ -z "$mac" ]; then continue; fi
            prev_ip=$(echo "$line" | awk '{print $1}')
            if ! grep -q "^$prev_ip " <<< "$current_scan"; then
                echo "[-] Device left → $prev_ip"
            fi
        done < "$PREV_SCAN"
    fi

    # Detect joined devices
    while IFS= read -r line; do
ip=$(echo "$line" | awk '{print $1}')
mac=$(echo "$line" | awk '{print $2}')
if [ -z "$ip" ] || [ -z "$mac" ]; then continue; fi
        curr_ip=$(echo "$line" | awk '{print $1}')
        curr_mac=$(echo "$line" | awk '{print $2}')
        curr_vendor=$(echo "$line" | awk '{print $3}')
        if ! grep -q "^$curr_ip " "$PREV_SCAN" 2>/dev/null; then
            echo "[+] Device joined → $curr_ip | MAC: $curr_mac | Vendor: $curr_vendor"
        fi
    done <<< "$current_scan"

    # Save current scan
    echo "$current_scan" > $PREV_SCAN

    # Wait 10 seconds before next scan
    sleep 10
done




work_monitor.sh - live network monitor using nmap

# Files to store previous scan and vendor cache
PREV_SCAN="/tmp/prev_scan.txt"
MAC_CACHE="/tmp/mac_cache.txt"

# Ensure files exist
touch $PREV_SCAN
touch $MAC_CACHE

# Function to get vendor for MAC
get_vendor() {
    local mac="$1"
    # Check cache first
    vendor=$(grep -i "^$mac " $MAC_CACHE | awk '{print $2}')
    if [ -n "$vendor" ]; then
        echo "$vendor"
        return
    fi

    # API call with throttling
    sleep 1
    response=$(curl -s "https://api.macvendors.com/$mac")
    if [ -n "$response" ]; then
        echo "$mac $response" >> $MAC_CACHE
        echo "$response"
    else
        echo "Unknown"
    fi
}

# Main loop
while true; do
    # Scan network with nmap
    nmap_output=$(sudo nmap -sn 192.168.2.0/24)

    current_scan=""

    # Parse nmap output
    ip=""
    echo "$nmap_output" | while read -r line; do
        if [[ $line =~ Nmap\ scan\ report\ for\ ([0-9.]+) ]]; then
            ip="${BASH_REMATCH[1]}"
        elif [[ $line =~ MAC\ Address:\ ([0-9A-F:]+)\ \((.*)\) ]]; then
            mac="${BASH_REMATCH[1]}"
            vendor="${BASH_REMATCH[2]}"
            current_scan+="$ip $mac $vendor"$'\n'
        fi
    done

    # Compare with previous scan
    while read -r line; do
        scan_ip=$(echo "$line" | awk '{print $1}')
        if ! grep -q "^$scan_ip " <<< "$current_scan"; then
            echo "[-] Device left → $scan_ip"
        fi
    done <<< "$(cat $PREV_SCAN)"

    while read -r line; do
        scan_ip=$(echo "$line" | awk '{print $1}')
        scan_mac=$(echo "$line" | awk '{print $2}')
        scan_vendor=$(echo "$line" | awk '{print $3}')
        if ! grep -q "^$scan_ip " "$(cat $PREV_SCAN)" 2>/dev/null; then
            echo "[+] Device joined → $scan_ip | MAC: $scan_mac | Vendor: $scan_vendor"
        fi
    done <<< "$current_scan"

    # Save current scan
    echo "$current_scan" > $PREV_SCAN

    # Wait 10 seconds before next scan
    sleep 10
done#!/bin/bash

# network_monitor.sh

# File to store previous scan
PREV_SCAN="/tmp/prev_scan.txt"
# File to cache MAC -> Vendor mappings
MAC_CACHE="/tmp/mac_cache.txt"

# IP range to scan
IP_RANGE="192.168.2.0/24"

# Ensure cache exists
touch $MAC_CACHE
touch $PREV_SCAN

# Function to get vendor for a MAC
get_vendor() {
    local mac=$1
    # Check cache first
    vendor=$(grep -i "^$mac " $MAC_CACHE | awk '{print $2}')
    if [ -n "$vendor" ]; then
        echo $vendor
        return
    fi

    # Call API (throttle requests)
    sleep 1
    response=$(curl -s "https://api.macvendors.com/$mac")
    if [ -n "$response" ]; then
        echo "$mac $response" >> $MAC_CACHE
        echo "$response"
    else
        echo "Unknown"
    fi
}

# Scan the network
current_scan=$(arp -an | awk '/192\.168\.2\./ {gsub("[()]", ""); print $2" "$4}')

# Compare with previous scan
while read -r line; do
    ip=$(echo $line | awk '{print $1}')
    mac=$(echo $line | awk '{print $2}')
    if ! grep -q "^$ip " $PREV_SCAN; then
        vendor=$(get_vendor $mac)
        echo "[+] Device joined → $ip | MAC: $mac | Vendor: $vendor"
    fi
done <<< "$current_scan"

while read -r line; do
    ip=$(echo $line | awk '{print $1}')
    if ! grep -q "^$ip " <<< "$current_scan"; then
        echo "[-] Device left → $ip"
    fi
done <<< "$(cat $PREV_SCAN)"

# Save current scan for next run
echo "$current_scan" > $PREV_SCAN#!/bin/bash

# Real-time network monitor with MAC and vendor info
NETWORK="192.168.2.0/24"
PREV_LIST=""

while true; do
    # Get the current list of IPs
    CUR_LIST=$(nmap -sn $NETWORK | grep "Nmap scan report" | awk '{print $5}')

    # Check for new devices
    for ip in $CUR_LIST; do
        if ! grep -q $ip <<< "$PREV_LIST"; then
            # Get MAC address (if available)
            MAC=$(arp -n $ip | awk '/ether/ {print $3}')
            if [ -n "$MAC" ]; then
                # Get vendor
                VENDOR=$(curl -s https://api.macvendors.com/$MAC)
                echo "[+] Device joined → $ip | MAC: $MAC | Vendor: $VENDOR"
            else
                echo "[+] Device joined → $ip | MAC: unknown"
            fi
        fi
    done

    # Check for devices that left
    for ip in $PREV_LIST; do
        if ! grep -q $ip <<< "$CUR_LIST"; then
            echo "[-] Device left → $ip"
        fi
    done

    PREV_LIST="$CUR_LIST"
    sleep 10
done
#!/bin/bash

# Simple real-time network monitor
NETWORK="192.168.2.0/24"
PREV_LIST=""

while true; do
    CUR_LIST=$(nmap -sn $NETWORK | grep "Nmap scan report" | awk '{print $5}')

    # New devices
    for ip in $CUR_LIST; do
        if ! grep -q $ip <<< "$PREV_LIST"; then
            echo "[+] Device joined → $ip"
        fi
    done

    # Left devices
    for ip in $PREV_LIST; do
        if ! grep -q $ip <<< "$CUR_LIST"; then
            echo "[-] Device left → $ip"
        fi
    done

    PREV_LIST="$CUR_LIST"
    sleep 10
done
#!/bin/bash

# Simple real-time network monitor
NETWORK="192.168.2.0/24"
PREV_LIST=""

while true; do
    CUR_LIST=$(nmap -sn $NETWORK | grep "Nmap scan report" | awk '{print $5}')

    # New devices
    for ip in $CUR_LIST; do
        if ! grep -q $ip <<< "$PREV_LIST"; then
            echo "[+] Device joined → $ip"
        fi
    done

    # Left devices
    for ip in $PREV_LIST; do
        if ! grep -q $ip <<< "$CUR_LIST"; then
            echo "[-] Device left → $ip"
        fi
   done

    PREV_LIST="$CUR_LIST"
    sleep 10
done
