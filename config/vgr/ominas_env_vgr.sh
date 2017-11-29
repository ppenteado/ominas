#!/bin/sh
# ominas_env_vgr.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Voyager setup for bash						    #
#       The copy of this file at ~/.ominas/config is overwritten by the installer   #
#										    #
#-----------------------------------------------------------------------------------#

OMINAS_VGR=${OMINAS_DIR}/config/vgr/
export OMINAS_VGR
NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_VGR}/tab/translators.tab
export NV_TRANSLATORS
NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_VGR}/tab/transforms.tab
export NV_TRANSFORMS
NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_VGR}
export NV_SPICE_KER
NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_VGR}/tab/instrument_detectors.tab
export NV_INS_DETECT


if ! [ -z ${1+x} ]; then
	pool=$1
	if ! [ -d "${pool}/ck" ]; then pool="${pool}/kernels"; fi
	sclk="sclk"
	if ! [ -d "${pool}/$sck" ]; then sclk="sck"; fi
    VGR_SPICE_CK=${pool}/ck/
    export VGR_SPICE_CK
    VGR_SPICE_EK=${pool}/ek/
    export VGR_SPICE_EK
    VGR_SPICE_FK=${pool}/fk/
    export VGR_SPICE_FK
    VGR_SPICE_IK=${pool}/ik/
    export VGR_SPICE_IK
#    VGR_SPICE_LSK=${pool}/lsk/
    VGR_SPICE_LSK=${pool}/../Generic_kernels/lsk/
    export VGR_SPICE_LSK
#    VGR_SPICE_PCK=${pool}/pck/
    VGR_SPICE_PCK=${pool}/../Generic_kernels/pck/
    export VGR_SPICE_PCK
    VGR_SPICE_SCK=${pool}/$sclk/
    export VGR_SPICE_SCK
    VGR_SPICE_SPK=${pool}/spk/
    export VGR_SPICE_SPK
fi
