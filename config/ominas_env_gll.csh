# ominas_env_gll.csh
#-----------------------------------------------------------------------------------#
#	OMINAS Galilieo setup for (t)csh												#
#																					#
#-----------------------------------------------------------------------------------#

setenv OMINAS_GLL       ${OMINAS_DIR}/config/gll/
setenv NV_TRANSLATORS   ${NV_TRANSLATORS}:${OMINAS_GLL}/tab/translators.tab
setenv NV_TRANSFORMS    ${NV_TRANSFORMS}:${OMINAS_GLL}/tab/transforms.tab
setenv NV_SPICE_KER     ${NV_SPICE_KER}:${OMINAS_GLL}
setenv NV_INS_DETECT    ${NV_INS_DETECT}:${OMINAS_GLL}/tab/instrument_detectors.tab