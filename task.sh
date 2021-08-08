#!/bin/bash

###################################################
################## VARIABLES ######################
###################################################

USER_NAME=`echo "$1"`
NUMBER=`echo "$2"`
FILE_ADDRESS="/usr/local/directadmin/data/users/$USER_NAME/httpd.conf"

###################################################
########## Arguments Validation ###################
###################################################
if [[ ! -n $1 ]] ||	[[ ! -n $2 ]] 
then
	echo -e "\033[31m [Error] Invalid command \033[m"	>&2
	exit 1 
fi

###################################################
######## Arguments Verification ###################
###################################################
# [[ $USER_NAME == [^[:digit:]] ]] && echo "[Error] Invalid User"	>&2 && 	exit 1 

### Cheking input Number is consisted of only digits.
[[ $NUMBER =~ [^[:digit:]] ]] && echo -e "\033[31m [Error] Invalid Worker Number \033[m"	>&2 && 	exit 1 

### Cheking file for the specified user exists.
if [[ ! -e "$FILE_ADDRESS" ]]
then
	echo -e "\033[31m [Error] There is no httpd.conf for USER: $USER_NAME " >&2
	exit 1
fi

###################################################
################# Main Functions ##################
###################################################

## debugging
#echo -e "$NUMBER, $USER_NAME, $FILE_ADDRESS "

if [[ `grep -i "LSPHP_Workers" $FILE_ADDRESS ` ]]
then
	sed -i -E "s/^  LSPHP_Workers [[:digit:]]+/  LSPHP_Workers $NUMBER/; t; s/^  LSPHP_Workers.*/  LSPHP_Workers $NUMBER/; t; s/^ LSPHP_Workers [[:digit:]]+/  LSPHP_Workers $NUMBER/; t; s/^LSPHP_Workers [[:digit:]]+/  LSPHP_Workers $NUMBER/" $FILE_ADDRESS
	[[ $? -eq 0 ]] && echo -e "\033[32m Changed to $NUMBER \033[m"
else
	echo -e "\n<IfModule LiteSpeed>\n  LSPHP_Workers $NUMBER\n</IfModule>\n" >> $FILE_ADDRESS
	[[ $? -eq 0 ]] && echo -e "\033[32m Worker parameter $NUMBER Added \033[m"
fi

