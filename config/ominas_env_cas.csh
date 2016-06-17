# ominas_env_cas.csh
#-----------------------------------------------------------------------------------#
#	OMINAS Cassini setup for (t)csh													#
#																					#
#-----------------------------------------------------------------------------------#

setenv OMINAS_CAS       ${OMINAS_DIR}/config/cas/
setenv NV_TRANSLATORS   ${NV_TRANSLATORS}:${OMINAS_CAS}/tab/translators.tab
setenv NV_TRANSFORMS    ${NV_TRANSFORMS}:${OMINAS_CAS}/tab/transforms.tab
setenv NV_SPICE_KER     ${NV_SPICE_KER}:${OMINAS_CAS}
setenv NV_INS_DETECT    ${NV_INS_DETECT}:${OMINAS_CAS}/tab/instrument_detectors.tab