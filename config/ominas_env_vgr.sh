# ominas_env_vgr.sh
#-----------------------------------------------------------------------------------#
#	OMINAS Voyager setup for bash													#
#																					#
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