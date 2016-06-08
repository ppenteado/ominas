# ominas_env_gll.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Galileo setup for bash													#
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