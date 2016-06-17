# ominas_env_dawn.csh
#-----------------------------------------------------------------------------------#
#	OMINAS Dawn setup for (t)csh													#
#																					#
#-----------------------------------------------------------------------------------#

setenv OMINAS_DAWN      ${OMINAS_DIR}/config/dawn/
setenv NV_TRANSLATORS   ${NV_TRANSLATORS}:${OMINAS_DAWN}/tab/translators.tab
setenv NV_TRANSFORMS    ${NV_TRANSFORMS}:${OMINAS_DAWN}/tab/transforms.tab
setenv NV_SPICE_KER     ${NV_SPICE_KER}:${OMINAS_DAWN}
setenv NV_INS_DETECT    ${NV_INS_DETECT}:${OMINAS_DAWN}/tab/instrument_detectors.tab