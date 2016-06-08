# ominas_env_cas.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Cassini setup for bash													#
#																					#
#-----------------------------------------------------------------------------------#

OMINAS_CAS=${OMINAS_DIR}/config/cas/
export OMINAS_CAS
NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_CAS}/tab/translators.tab
export NV_TRANSLATORS
NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_CAS}/tab/transforms.tab
export NV_TRANSFORMS
NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_CAS}
export NV_SPICE_KER
NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_CAS}/tab/instrument_detectors.tab
export NV_INS_DETECT