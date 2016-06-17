# ominas_env_vgr.csh
#-----------------------------------------------------------------------------------#
#	OMINAS Voyager setup for (t)csh													#
#																					#
#-----------------------------------------------------------------------------------#

setenv OMINAS_VGR       ${OMINAS_DIR}/config/vgr/
setenv NV_TRANSLATORS   ${NV_TRANSLATORS}:${OMINAS_VGR}/tab/translators.tab
setenv NV_TRANSFORMS    ${NV_TRANSFORMS}:${OMINAS_VGR}/tab/transforms.tab
setenv NV_SPICE_KER     ${NV_SPICE_KER}:${OMINAS_VGR}
setenv NV_INS_DETECT    ${NV_INS_DETECT}:${OMINAS_VGR}/tab/instrument_detectors.tab