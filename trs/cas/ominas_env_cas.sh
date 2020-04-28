#!/bin/sh
# ominas_env_cas.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Cassini setup for sh   						    #
#       The copy of this file at ~/.ominas/config is overwritten by the installer   #
#-----------------------------------------------------------------------------------#

OMINAS_CAS=${OMINAS_DIR}/config/cas
export OMINAS_CAS
NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_CAS}/tab/translators.tab
export NV_TRANSLATORS
NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_CAS}/tab/transforms.tab
export NV_TRANSFORMS
NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_CAS}
export NV_SPICE_KER
NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_CAS}/tab/instrument_detectors.tab
export NV_INS_DETECT


if ! [ -z ${1+x} ]; then
    pool=$1
    if ! [ -d "${pool}/ck" ]; then pool="${pool}/kernels"; fi
    sclk="sclk"
    if ! [ -d "${pool}/$sck" ]; then sclk="sck"; fi
    CAS_SPICE_CK=${pool}/ck/
    export CAS_SPICE_CK
    CAS_SPICE_EK=${pool}/ek/
    export CAS_SPICE_EK
    CAS_SPICE_FK=${pool}/fk/
    export CAS_SPICE_FK
    CAS_SPICE_IK=${pool}/ik/
    export CAS_SPICE_IK
    CAS_SPICE_LSK=${pool}/lsk/
    export CAS_SPICE_LSK
    CAS_SPICE_PCK=${pool}/pck/
    export CAS_SPICE_PCK
    CAS_SPICE_SCK=${pool}/$sclk/
    export CAS_SPICE_SCK
    CAS_SPICE_SPK=${pool}/spk/
    export CAS_SPICE_SPK

    CAS_ISS_PSF=${pool}/iss/psf/
    export CAS_ISS_PSF
fi
