#!/bin/bash

# Get the primary network interface (typically en0 for Wi-Fi)
INTERFACE=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

# Generate a random MAC address (preserving locally administered and unicast bits)
RAND_MAC=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
RAND_MAC="02:${RAND_MAC:3}"  # Ensure it's a locally administered address

# Display the generated MAC address and ask for confirmation
echo "Generated MAC Address: $RAND_MAC"
read -p "Do you want to change your MAC address to this? (y/N): " CONFIRM

# Convert input to lowercase
CONFIRM=$(echo "$CONFIRM" | tr '[:upper:]' '[:lower:]')

if [[ "$CONFIRM" == "y" || "$CONFIRM" == "yes" ]]; then
    echo "Changing MAC address to $RAND_MAC..."

    # Disable the interface before changing MAC
    sudo ifconfig "$INTERFACE" down

    # Change MAC address
    sudo ifconfig "$INTERFACE" ether "$RAND_MAC"

    # Enable the interface back
    sudo ifconfig "$INTERFACE" up

    # Verify the change
    NEW_MAC=$(ifconfig "$INTERFACE" | awk '/ether/{print $2}')
    echo "New MAC Address: $NEW_MAC"
else
    echo "MAC address change canceled."
    exit 1
fi
