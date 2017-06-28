#!/bin/sh
# ominas_env_strcat.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Star catalogs setup for sh                                           #
#										    #
#-----------------------------------------------------------------------------------#

#declare OMINAS_${1}=${OMINAS_DIR}/config/${1}
#varname=OMINAS_${1}
#export $varname
NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_DIR}/strcat/tab/translators-common.tab:${OMINAS_DIR}/strcat/tab/translators-${1}.tab
export NV_TRANSLATORS
