#!/bin/sh
# ominas_env_dawn.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Dawn setup for bash														#
#																					#
#-----------------------------------------------------------------------------------#

OMINAS_DAWN=${OMINAS_DIR}/config/dawn/
export OMINAS_DAWN
NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_DAWN}/tab/translators.tab
export NV_TRANSLATORS
NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_DAWN}/tab/transforms.tab
export NV_TRANSFORMS
NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_DAWN}
export NV_SPICE_KER
NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_DAWN}/tab/instrument_detectors.tab
export NV_INS_DETECT

if ! [ -z ${1+x} ]; then
	pool=$1
	if ! [ -d "${pool}/ck" ]; then pool="${pool}/kernels"; fi
	sclk="sclk"
	if ! [ -d "${pool}/$sck" ]; then sclk="sck"; fi
    DAWN_SPICE_CK=${pool}/ck/
    export DAWN_SPICE_CK
    DAWN_SPICE_EK=${pool}/ek/
    export DAWN_SPICE_EK
    DAWN_SPICE_FK=${pool}/fk/
    export DAWN_SPICE_FK
    DAWN_SPICE_IK=${pool}/ik/
    export DAWN_SPICE_IK
    DAWN_SPICE_LSK=${pool}/lsk/
    export DAWN_SPICE_LSK
    DAWN_SPICE_PCK=${pool}/pck/
    export DAWN_SPICE_PCK
    DAWN_SPICE_SCK=${pool}/$sclk/
    export DAWN_SPICE_SCK
    DAWN_SPICE_SPK=${pool}/spk/
    export DAWN_SPICE_SPK
fi