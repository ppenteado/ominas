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