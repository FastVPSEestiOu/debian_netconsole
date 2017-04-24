#!/bin/bash

ACTION=$1
NAME=netconsole

case $ACTION in 
    start )
        # Exit if we already have netconsole loaded
        if lsmod | grep -q "^$NAME"; then
            echo "Module $NAME is already loaded. Exiting."
            exit 1
        fi

        # Define needed variables
        DESTINATION_SERVER_MAC=''
        SOURCE_PORT=''
        DEFAULT_CONF='/etc/default/netconsole'
        
        # Load variables from defaults
        test -r $DEFAULT_CONF && . $DEFAULT_CONF
        
        if [ "$ENABLE_NETCONSOLE" = yes ]; then
            # Exit if we have no DESTINATION_SERVER_IP
            if [ -z "$DESTINATION_SERVER_IP" ]; then
                echo "Please set DESTINATION_SERVER_IP variable in $DEFAULT_CONF or disable $NAME module."
                exit 1
            fi
        
            # Set GATEWAY_IP and SOURCE_IP from route to DESTINATION_SERVER_IP
            read GATEWAY_IP SOURCE_INTERFACE SOURCE_IP <<< $(ip -o route get $DESTINATION_SERVER_IP | grep src | awk '{print $3, $5, $7}')
            
            # If DESTINATION_SERVER_MAC is not defined explicitly we use gateway mac address
            if [ -z "$DESTINATION_SERVER_MAC" ]; then
                GATEWAY_MAC=$(arp "$GATEWAY_IP" | grep "$SOURCE_INTERFACE" | grep -oE  '[a-z0-9:]{17}')

                # If we have no arp record for gateway - ping DESTINATION_SERVER_IP to fill arp table and retry
                if [ -z "$GATEWAY_MAC" ]; then
                    ping -n -q -c 3 -i 0.1 $DESTINATION_SERVER_IP > /dev/null
                    GATEWAY_MAC=$(arp "$GATEWAY_IP" | grep "$SOURCE_INTERFACE" | grep -oE  '[a-z0-9:]{17}')

                    # If we still have no MAC - exiting
                    if [ -z "$GATEWAY_MAC" ]; then
                        echo "We can't get GATEWAY_MAC and no DESTINATION_SERVER_MAC set. Exiting."
                        exit 1
                    fi
                fi
                DESTINATION_SERVER_MAC=$GATEWAY_MAC
            fi
        
            # Set SOURCE_PORT 
            if [ -z "$SOURCE_PORT" ]; then
                SOURCE_PORT="6666"
            fi
            
            # Encrease logging level up to 8, because standard debian has 7 and did not send many messages to netconsole$
            # # https://www.kernel.org/doc/Documentation/sysctl/kernel.txt
            echo 8 > /proc/sys/kernel/printk
            
            # Form options line
            MODULE_OPTIONS="$NAME=$SOURCE_PORT@$SOURCE_IP/$SOURCE_INTERFACE,$DESTINATION_PORT@$DESTINATION_SERVER_IP/$DESTINATION_SERVER_MAC"
            
            # Actualy load module
            if modprobe $NAME "$MODULE_OPTIONS"; then
                echo "Loaded $NAME."
                exit 0
            else
                echo "Failed to load $NAME."
            fi
        else
            echo "Netconsole is disabled in $DEFAULT_CONF, if you need it, please enable."
            exit 1
        fi
    ;;
    stop )
        if ! lsmod | grep -q "^$NAME"; then
            echo "Module $NAME is not loaded. Exiting."
            exit 0
        fi

        if modprobe -r $NAME; then
            echo "Unloaded $NAME"
            exit 0
        else
            echo "Failed to unload $NAME"
            exit 1
        fi
    ;;
    * )
        SCRIPT_NAME=`basename $0`
        echo "Usage: $SCRIPT_NAME <start|stop>"
    ;;
esac
