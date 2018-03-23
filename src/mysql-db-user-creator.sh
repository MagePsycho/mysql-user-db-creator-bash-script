#!/bin/bash

#
# Script to create MySQL db + user
#
# @author   Raj KB <magepsycho@gmail.com>
# @website  http://www.magepsycho.com
# @version  0.1.0

################################################################################
# CORE FUNCTIONS - Do not edit
################################################################################
#
# VARIABLES
#
_bold=$(tput bold)
_underline=$(tput sgr 0 1)
_reset=$(tput sgr0)

_purple=$(tput setaf 171)
_red=$(tput setaf 1)
_green=$(tput setaf 76)
_tan=$(tput setaf 3)
_blue=$(tput setaf 38)

#
# HEADERS & LOGGING
#
function _debug()
{
    [ "$DEBUG" -eq 1 ] && $@
}

function _header()
{
    printf "\n${_bold}${_purple}==========  %s  ==========${_reset}\n" "$@"
}

function _arrow()
{
    printf "➜ $@\n"
}

function _success()
{
    printf "${_green}✔ %s${_reset}\n" "$@"
}

function _error() {
    printf "${_red}✖ %s${_reset}\n" "$@"
}

function _warning()
{
    printf "${_tan}➜ %s${_reset}\n" "$@"
}

function _underline()
{
    printf "${_underline}${_bold}%s${_reset}\n" "$@"
}

function _bold()
{
    printf "${_bold}%s${_reset}\n" "$@"
}

function _note()
{
    printf "${_underline}${_bold}${_blue}Note:${_reset}  ${_blue}%s${_reset}\n" "$@"
}

function _die()
{
    _error "$@"
    exit 1
}

function _safeExit()
{
    exit 0
}

#
# UTILITY HELPER
#
function _seekConfirmation()
{
  printf "\n${_bold}$@${_reset}"
  read -p " (y/n) " -n 1
  printf "\n"
}

# Test whether the result of an 'ask' is a confirmation
function _isConfirmed()
{
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        return 0
    fi
    return 1
}


function _typeExists()
{
    if [ $(type -P $1) ]; then
        return 0
    fi
    return 1
}

function _isOs()
{
    if [[ "${OSTYPE}" == $1* ]]; then
      return 0
    fi
    return 1
}

function _checkRootUser()
{
    #if [ "$(id -u)" != "0" ]; then
    if [ "$(whoami)" != 'root' ]; then
        echo "You have no permission to run $0 as non-root user. Use sudo"
        exit 1;
    fi

}

function _printPoweredBy()
{
    cat <<"EOF"

Powered By:
   __  ___              ___               __
  /  |/  /__ ____ ____ / _ \___ __ ______/ /  ___
 / /|_/ / _ `/ _ `/ -_) ___(_-</ // / __/ _ \/ _ \
/_/  /_/\_,_/\_, /\__/_/  /___/\_, /\__/_//_/\___/
            /___/             /___/

 >> Store: http://www.magepsycho.com
 >> Blog: http://www.blog.magepsycho.com

################################################################
EOF
}
################################################################################
# SCRIPT FUNCTIONS
################################################################################
function generatePassword()
{
    echo "$(openssl rand -base64 12)"
}

function _printUsage()
{
    echo -n "$(basename $0) [OPTION]...

Create MySQL db & user.
Version $VERSION

    Options:
        -h, --host        MySQL Host
        -d, --database    MySQL Database
        -u, --user        MySQL User
        -p, --pass        MySQL Password (If empty, auto-generated)
        -h, --help        Display this help and exit
        -v, --version     Output version information and exit

    Examples:
        $(basename $0) --help

"
    _printPoweredBy
    exit 1
}

function processArgs()
{
    # Parse Arguments
    for arg in "$@"
    do
        case $arg in
            -h=*|--host=*)
                DB_HOST="${arg#*=}"
            ;;
            -d=*|--database=*)
                DB_NAME="${arg#*=}"
            ;;
            -u=*|--user=*)
                DB_USER="${arg#*=}"
            ;;
             -p=*|--pass=*)
                DB_PASS="${arg#*=}"
            ;;
            --debug)
                DEBUG=1
            ;;
            -h|--help)
                _printUsage
            ;;
            *)
                _printUsage
            ;;
        esac
    done
    [[ -z $DB_NAME ]] && _error "Database name cannot be empty." && exit 1
    [[ $DB_USER ]] || DB_USER=$DB_NAME
}

function createMysqlDbUser()
{
    SQL1="CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
    SQL2="CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';"
    SQL3="GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
    SQL4="FLUSH PRIVILEGES;"

    if [ -f /root/.my.cnf ]; then
        $BIN_MYSQL -e "${SQL1}${SQL2}${SQL3}${SQL4}"
    else
        # If /root/.my.cnf doesn't exist then it'll ask for root password
        _arrow "Please enter root user MySQL password!"
        read rootPassword
        $BIN_MYSQL -h $DB_HOST -u root -p${rootPassword} -e "${SQL1}${SQL2}${SQL3}${SQL4}"
    fi
}

function printSuccessMessage()
{
    _success "MySQL DB / User creation completed!"

    echo "################################################################"
    echo ""
    echo " >> Host      : ${DB_HOST}"
    echo " >> Database  : ${DB_NAME}"
    echo " >> User      : ${DB_USER}"
    echo " >> Pass      : ${DB_PASS}"
    echo ""
    echo "################################################################"
    _printPoweredBy

}

################################################################################
# Main
################################################################################
export LC_CTYPE=C
export LANG=C

DEBUG=0 # 1|0
_debug set -x
VERSION="0.1.0"

BIN_MYSQL=$(which mysql)

DB_HOST='localhost'
DB_NAME=
DB_USER=
DB_PASS=$(generatePassword)

function main()
{
    [[ $# -lt 1 ]] && _printUsage
    _success "Processing arguments..."
    processArgs "$@"
    _success "Done!"

    _success "Creating MySQL db and user..."
    createMysqlDbUser
    _success "Done!"

    printSuccessMessage

    exit 0
}

main "$@"

_debug set +x