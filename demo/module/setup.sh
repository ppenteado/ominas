#-----------------------------------------------------------------------------------#
# DEMO configuration:																    #
#-----------------------------------------------------------------------------------#
export OMINAS_DEMO_DATA=${OMINAS_DEMO}/data

export OMINAS_SPICE_KLIST=${OMINAS_SPICE_KLIST}:${OMINAS_DEMO_DATA}
export OMINAS_TRS_STRCAT_SAO_DATA=${OMINAS_DEMO_DATA}
export OMINAS_DAT_MAP_DATA=${OMINAS_DEMO_DATA}/maps/
#export CAS_ISS_PSF=${OMINAS_DEMO_DATA}/psfs/
export OMINAS_DEMO_KERNELS=${OMINAS_DEMO_DATA}/kernels/
export DEMO_SPICE_PCK=${OMINAS_DEMO_KERNELS}/pck/
export DEMO_SPICE_FK=${OMINAS_DEMO_KERNELS}/fk/
export DEMO_SPICE_IK=${OMINAS_DEMO_KERNELS}/ik/
export DEMO_SPICE_SCK=${OMINAS_DEMO_KERNELS}/sck/
export DEMO_SPICE_LSK=${OMINAS_DEMO_KERNELS}/lsk/
export DEMO_SPICE_CK=${OMINAS_DEMO_KERNELS}/ck/
export DEMO_SPICE_SPK=${OMINAS_DEMO_KERNELS}/spk/
export DEMO_SPICE_XK=$OMINAS_SPICE/
