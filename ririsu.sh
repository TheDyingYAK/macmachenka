#!/bin/bash

# Get the primary network interface (typically en0 for Wi-Fi)
INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

echo "Releasing current DHCP lease..."
sudo ifconfig "$INTERFACE" down

echo "Bringing interface back up..."
sudo ifconfig "$INTERFACE" up

echo "Requesting a new DHCP lease..."
sudo dhclient "$INTERFACE" || sudo networksetup -renewdhcp "$INTERFACE"

# Display the new IP address
NEW_IP=$(ipconfig getifaddr "$INTERFACE")
echo "New IP Address: $NEW_IP"
