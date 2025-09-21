#!/bin/bash

# microsocks environment variables
MICROSOCKS_USER="${MICROSOCKS_USER}"
MICROSOCKS_PASSWORD="${MICROSOCKS_PASSWORD}"
MICROSOCKS_AUTHONCE="${MICROSOCKS_AUTHONCE}"


echo " [-] Configuring microsocks auth args..."
AUTHARGS=""
USERNAME_CHECK="true"
PASSWORD_CHECK="true"
AUTHONCE_CHECK="true"


# check for username
if [ -z "$MICROSOCKS_USER" ]; then
    USERNAME_CHECK="false"
    echo "      MICROSOCKS_USER is not set!"
else
    AUTHARGS="${AUTHARGS} -u ${MICROSOCKS_USER}"
fi
# check for password
if [ -z "$MICROSOCKS_PASSWORD" ]; then
    PASSWORD_CHECK="false"
    echo "      MICROSOCKS_PASSWORD is not set!"
else
    AUTHARGS="${AUTHARGS} -P ${MICROSOCKS_PASSWORD}"
fi
# check if both are empty or set
if [ "$PASSWORD_CHECK" != "$USERNAME_CHECK" ]; then
    echo "      Both MICROSOCKS_USER and MICROSOCKS_PASSWORD need to be set!"
    exit 1
fi


# set authonce only if both are set
if [[ "$PASSWORD_CHECK" == "false" && "$USERNAME_CHECK" == "false" ]]; then
    echo "      disabling authonce! since both or one of username and password are not set!"
    AUTHONCE_CHECK="false"
fi
# but if authonce is set to false, then disable it
if [ "$MICROSOCKS_AUTHONCE" == "false" ]; then
    echo "      MICROSOCKS_AUTHONCE is set to false!"
    AUTHONCE_CHECK="false"
fi
# final check if authonce is should be added or not
if [ "$AUTHONCE_CHECK" == "true" ]; then
    echo "      authonce enabled!"
    AUTHARGS="${AUTHARGS} -1"
fi