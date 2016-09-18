#!/bin/bash

############################################# FUNCTIONS

create-auth-file() {
    echo "Enter your credentials..."

    echo -n "Username: "
    read username

    echo -n "Password: "
    read -s password
    echo 

    touch /etc/openvpn/auth.txt
    echo $username >> /etc/openvpn/auth.txt
    echo $password >> /etc/openvpn/auth.txt
}

############################################## START OF SCRIPT 

# only let this script run in root mode
if [ "$EUID" -ne 0 ]; then
    echo 'Please run as root'
    exit
fi

# ensure there is a valid file path (most likely to a .ovpn file) as an argument
if [ -z "$1" -o ! -f "$1" ]; then
    echo 'Please pass an ovpn file as an argument'
    exit
fi 

# Step 1: check if auth file exists
echo -n "Checking if auth.txt exists..."

if [ -f /etc/openvpn/auth.txt ]; then
    echo "it exists!"
else
    echo "it doesn't"
    create-auth-file
fi

# Step 2: check if auth-user-pass exists in the file, then inject the auth file
echo -n "Injecting option into .ovpn file..."



if grep -Fxq "auth-user-pass" "$1"; then
    # sed is magical
    sed -i 's@auth-user-pass$@auth-user-pass /etc/openvpn/auth.txt@' "$1"
    echo "done"
else
    echo
    echo 'ERROR: Input file does not contain the option auth-user-pass (or it has already been assigned)'
fi

