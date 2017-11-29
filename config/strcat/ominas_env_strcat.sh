#!/bin/sh
# ominas_env_strcat.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Star catalogs setup for sh                                           #
#	The copy of this file at ~/.ominas/config is overwritten by the installer   #
#-----------------------------------------------------------------------------------#

#declare OMINAS_${1}=${OMINAS_DIR}/config/${1}
#varname=OMINAS_${1}
#export $varname

OMINAS_STRCAT=${OMINAS_DIR}/config/strcat
export OMINAS_STRCAT

NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_STRCAT}/tab/translators-${1}.tab:${OMINAS_STRCAT}/tab/translators-common.tab
export NV_TRANSLATORS
