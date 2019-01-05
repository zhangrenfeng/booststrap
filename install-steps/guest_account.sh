#!/bin/bash
# Program:
#   Enable the guest account based on OS version
# Reference:
#   https://github.com/nbalonso/Some_scripts/blob/master/Pushing%20Guest%20account/postflight.sh
# History:
#   2018/12/28      renfeng.zhang   0.1.0

source colorful.sh

dscl="/usr/bin/dscl"
security="/usr/bin/security"

function guest_enable()
{
    if [[ -f "/var/db/dslocal/nodes/Default/users/Guest.plist" ]]; then
        echo_blue "Guest was found on the system !"
        echo_blue "nothing done"
        echo_blue "Exiting now"
        exit 0
    else
        if [[ "$(sw_vers | grep -o '10\.6')" != "" ]]; then
            echo_blue "$0: Not implemented"
            logger -s "$0: Not implemented"
            exit 0
        fi

        echo_red "Operating system version not supported by this script"
        echo_red "Exiting now"
    fi
}

function guest_disable()
{
    $dscl . -delete /Users/Guest
    $security delete-generic-password -a Guest -s com.apple.loginwindow.guest-account -D "application password" /Library/Keychains/System.keychain

    defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool FALSE

    echo_green "$0: Guest account disabled"
    logger -s "$0: Guest account disabled"

    exit 0
}

case $(whoami) in
    'root' )
        ;;

    *)
        echo_red "Must be run as root"
        exit 0
        ;;
esac

case $1 in
    'enable' | 'true' | 'True' | 'TRUE' )
        echo_green "$0: Enableing the guest account"
        logger -s "$0: Enableing the guest account"
        guest_enable
        ;;
    'disable' | 'false' | 'False' | 'FALSE' )
        echo_green "$0: Disabling the guest account"
        logger -s "$0: Disabling the guest account"
        guest_disable
        ;;
    *)
        echo_blue "Usage: $0 enable|disable"
        ;;
esac