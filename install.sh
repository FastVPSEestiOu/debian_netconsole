#!/bin/bash
set -u

# Setting text colors
TXT_GRN='\e[0;32m'
TXT_RED='\e[0;31m'
TXT_YLW='\e[0;33m'
TXT_RST='\e[0m'

# Some fancy echoing
_echo_OK()
{
    echo -e "${TXT_GRN}OK${TXT_RST}"
}

_echo_FAIL()
{
    echo -e "${TXT_RED}FAIL${TXT_RST}"
}

_echo_result()
{
    local result=$@
    if [[ "$result" -eq 0 ]]; then
        _echo_OK
    else
        _echo_FAIL
        exit 1
    fi
}

# Detect OS
_detect_os()
{
    local issue_file='/etc/issue'
    local os_release_file='/etc/os-release'
    local redhat_release_file='/etc/redhat-release'
    local os=''
    # First of all, trying os-relese file
    if [ -f $os_release_file ]; then
        local name=`grep '^NAME=' $os_release_file | awk -F'[" ]' '{print $2}'`
        local version=`grep '^VERSION_ID=' $os_release_file | awk -F'[". ]' '{print $2}'`
        os="${name}${version}"
    else
        # If not, trying redhat-release file (mainly because of bitrix-env)
        if [ -f $redhat_release_file ]; then
            os=`head -1 /etc/redhat-release | sed -re 's/([A-Za-z]+)[^0-9]*([0-9]+).*$/\1\2/'`
        else
            # Else, trying issue file
            if [ -f $issue_file ]; then
                os=`head -1 $issue_file | sed -re 's/([A-Za-z]+)[^0-9]*([0-9]+).*$/\1\2/'` 
            else
                # If none of that files worked, exit
                echo -e "${TXT_RED}Cannot detect OS. Exiting now"'!'"${TXT_RST}"
                exit 1
            fi
        fi
    fi
    echo "${os}"        
}

# Warn user that we need ping utility
_check_ping()
{
    echo -ne "Testing ping utility... "
    local result=$(type ping >/dev/null 2>&1; echo $?)
    if [[ $result -eq 0 ]]; then
        _echo_OK
    else
        _echo_FAIL
    fi
}

_install()
{
    local os=$1
    case $os in
        Debian[8-9]|Debian1[0-1]|Ubuntu1[6-8]|Ubuntu2[0-2])
            echo -ne "Downloading config... "
            wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O /etc/default/netconsole --no-check-certificate -q
            _echo_result $?
        
            echo -ne "Downloading systemd service... "
            wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole.service -O /etc/systemd/system/netconsole.service --no-check-certificate -q
            _echo_result $?
            
            echo -ne "Downloading stop-start script... "
            wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole.sh -O /usr/local/bin/netconsole --no-check-certificate -q 
            _echo_result $?
            
            echo -ne "Installing net-tools .. "
            apt-get update -qq && apt-get install -qq net-tools > /dev/null
            _echo_result $?
            
            echo -ne "Performing chmod... "
            chmod +x /usr/local/bin/netconsole
            _echo_result $?
    
            echo -ne "Performing daemon-reload... "
            systemctl daemon-reload
            _echo_result $?
            
            echo -ne "Starting netconsole... "
            systemctl start netconsole.service
            _echo_result $?
            
            echo -ne "Enabling netconsole on boot... "
            systemctl -q enable netconsole.service > /dev/null
            _echo_result $?

            exit 0
        ;;
        Debian7|Ubuntu12|Ubuntu14 )
            echo -ne "Downloading config... "
            wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O /etc/default/netconsole --no-check-certificate -q
            _echo_result $?
    
            echo -ne "Downloading init script... "
            wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_sysv -O /etc/init.d/netconsole --no-check-certificate -q
            _echo_result $?
    
            echo -ne "Performing chmod... "
            chmod +x /etc/init.d/netconsole
            _echo_result $?
            
            echo -ne "Installing net-tools .. "
            apt-get update -qq && apt-get install -qq net-tools > /dev/null
            _echo_result $?
            
            echo -ne "Starting netconsole... "
            /etc/init.d/netconsole start > /dev/null
            _echo_result $?
            
            echo -ne "Enabling netconsole on boot... "
            update-rc.d netconsole defaults > /dev/null
            _echo_result $?

            exit 0
        ;;
        Debian6 )
            echo -ne "Downloading config... "
            wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_conf -O /etc/default/netconsole --no-check-certificate -q
            _echo_result $?
    
            echo -ne "Downloading init script... "
            wget https://raw.githubusercontent.com/FastVPSEestiOu/debian_netconsole/master/netconsole_sysv -O /etc/init.d/netconsole --no-check-certificate -q
            _echo_result $?
    
            echo -ne "Performing chmod... "
            chmod +x /etc/init.d/netconsole
            _echo_result $?
            
            echo -ne "Installing net-tools .. "
            apt-get update -o Acquire::Check-Valid-Until=false -qq && apt-get install --allow-unauthenticated -qq net-tools > /dev/null
            _echo_result $?
            
            echo -ne "Starting netconsole... "
            /etc/init.d/netconsole start > /dev/null
            _echo_result $?
            
            echo -ne "Enabling netconsole on boot... "
            update-rc.d netconsole defaults > /dev/null
            _echo_result $?

            exit 0
        ;;
        CentOS[5-8] )
            if yum list available netconsole-service > /dev/null; then
                echo -ne "Installing netconsole-service... "
                yum install -q -y netconsole-service > /dev/null
                _echo_result $?
            fi

            echo -ne "Setting remote server IP..."
            sed -i -e '/^SYSLOGADDR=/d' -e 's|\(# SYSLOGADDR=.*$\)|# SYSLOGADDR=\nSYSLOGADDR=148.251.39.245|g' /etc/sysconfig/netconsole
            _echo_result $?

            echo -ne "Setting remote server port..."
            sed -i -e '/^SYSLOGPORT=/d' -e 's|\(# SYSLOGPORT=.*$\)|\1\nSYSLOGPORT=614|g' /etc/sysconfig/netconsole
            _echo_result $?

            echo -ne "Starting netconsole... "
            service netconsole start > /dev/null
            _echo_result $?
            
            echo -ne "Enabling netconsole on boot... "
            chkconfig netconsole on > /dev/null
            _echo_result $?

            exit 0
        ;;
        * )
            echo "We can do nothing on $os. Exiting."
            exit 1
        ;;
    esac
}

OS=$(_detect_os)
echo -e "OS: ${TXT_YLW}${OS}${TXT_RST}"
_check_ping
_install $OS
