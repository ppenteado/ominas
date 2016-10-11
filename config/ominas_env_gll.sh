#!/bin/sh
# ominas_env_gll.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Galileo setup for sh														#
#																					#
#-----------------------------------------------------------------------------------#

OMINAS_GLL=${OMINAS_DIR}/config/gll/
export OMINAS_GLL
NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_GLL}/tab/translators.tab
export NV_TRANSLATORS
NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_GLL}/tab/transforms.tab
export NV_TRANSFORMS
NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_GLL}
export NV_SPICE_KER
NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_GLL}/tab/instrument_detectors.tab
export NV_INS_DETECT

if ! [ -z ${1+x} ]; then
	pool=$1
	if ! [ -d "${pool}/ck" ]; then pool="${pool}/kernels"; fi
	sclk="sclk"
	if ! [ -d "${pool}/$sck" ]; then sclk="sck"; fi
    GLL_SPICE_CK=${pool}/ck/
    export GLL_SPICE_CK
    GLL_SPICE_EK=${pool}/ek/
    export GLL_SPICE_EK
    GLL_SPICE_FK=${pool}/fk/
    export GLL_SPICE_FK
    GLL_SPICE_IK=${pool}/ik/
    export GLL_SPICE_IK
    GLL_SPICE_LSK=${pool}/lsk/
    export GLL_SPICE_LSK
    GLL_SPICE_PCK=${pool}/pck/
    export GLL_SPICE_PCK
    GLL_SPICE_SCK=${pool}/$sclk/
    export GLL_SPICE_SCK
    GLL_SPICE_SPK=${pool}/spk/
    export GLL_SPICE_SPK
fi