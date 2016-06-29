# ominas_env_cas.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Cassini setup for bash													#
#																					#
#-----------------------------------------------------------------------------------#

OMINAS_CAS=${OMINAS_DIR}/config/cas/
export OMINAS_CAS
NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_CAS}/tab/translators.tab
#NV_TRANSLATORS=${OMINAS_CAS}/tab/translators.tab
export NV_TRANSLATORS
NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_CAS}/tab/transforms.tab
#NV_TRANSFORMS=${OMINAS_CAS}/tab/transforms.tab
export NV_TRANSFORMS
NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_CAS}
#NV_SPICE_KER=${OMINAS_CAS}
export NV_SPICE_KER
NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_CAS}/tab/instrument_detectors.tab
#NV_INS_DETECT=${OMINAS_CAS}/tab/instrument_detectors.tab
export NV_INS_DETECT


#NV_SPICE_CK=${NV_SPICE_CK}:${SPICE_KER}/kernels/ck
#NV_SPICE_CK=${SPICE_KER}/kernels/ck/
#export NV_SPICE_CK
#NV_SPICE_EK=${NV_SPICE_EK}:${SPICE_KER}/kernels/ek
#NV_SPICE_EK=${SPICE_KER}/kernels/ek/
#export NV_SPICE_EK
#NV_SPICE_FK=${NV_SPICE_FK}:${SPICE_KER}/kernels/fk
#NV_SPICE_FK=${SPICE_KER}/kernels/fk/
#export NV_SPICE_FK
#NV_SPICE_IK=${NV_SPICE_IK}:${SPICE_KER}/kernels/ik
#NV_SPICE_IK=${SPICE_KER}/kernels/ik/
#export NV_SPICE_IK
#NV_SPICE_LSK=${NV_SPICE_LSK}:${SPICE_KER}/kernels/lsk
#NV_SPICE_LSK=${SPICE_KER}/kernels/lsk/
#export NV_SPICE_LSK
#NV_SPICE_PCK=${NV_SPICE_PCK}:${SPICE_KER}/kernels/pck
#NV_SPICE_PCK=${SPICE_KER}/kernels/pck/
#export NV_SPICE_PCK
#NV_SPICE_SCK=${NV_SPICE_SCK}:${SPICE_KER}/kernels/sclk
#NV_SPICE_SCK=${SPICE_KER}/kernels/sclk/
#export NV_SPICE_SCK
#NV_SPICE_SPK=${NV_SPICE_SPK}:${SPICE_KER}/kernels/spk
#NV_SPICE_SPK=${SPICE_KER}/kernels/spk/
#export NV_SPICE_SPK
