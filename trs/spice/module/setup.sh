#-----------------------------------------------------------------------------------#
# Generic Kernels:                                                                  #
#  The default OMINAS configuration also will set up the generic kernels. These     #
#  kernels can be used to supplement limited data sets, such as the Voyager SPICE   #
#  kernels.                                                                         #
#-----------------------------------------------------------------------------------#
export OMINAS_TRS_SPICE_KERNELS=${OMINAS_TRS_SPICE_DATA}/kernels
export SPICE_SPICE_PCK=${OMINAS_TRS_SPICE_KERNELS}/pck/
export SPICE_SPICE_FK=${OMINAS_TRS_SPICE_KERNELS}/fk/
export SPICE_SPICE_LSK=${OMINAS_TRS_SPICE_KERNELS}/lsk/
export SPICE_SPICE_SPK=${OMINAS_TRS_SPICE_KERNELS}/spk/
export SPICE_SPICE_DSK=${OMINAS_TRS_SPICE_KERNELS}/dsk/
