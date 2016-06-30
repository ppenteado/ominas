# ominas_env_def.sh
#----------------------------------------------------------------------------#
# OMINAS default setup for bash                                              #
#                                                                            #
#  This script configures the environment for OMINAS.  If you do not use sh, #
#  then you'll need to set these variables using syntax appropriate          #
#  to your preferred shell.                                                  #
#                                                                            #
#  This file will be overwritten when you upgrade your OMINAS installation   #
#  so you should copy it to another location before customizing it for       #
#  your system.  Then you can configure OMINAS using:                        #
#                                                                            #
#  source ominas_env.sh                                                      #
#                                                                            #
#----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#  These variables define a minimal configuration. Specific configurations    #
#  for various applications appear in the other package scripts.              #
#                                                                             #
#  This setup should allow you to run the first example script, which         #
#  enters all geometric information explicitly instead of accessing an        #
#  external source, which will require additional configuration (see below).  #
#  cd to $OMINAS_DIR/demo and type:                                           #
#                                                                             #
#    idl        saturn.example                                                #
#                                                                             #
#  You should see a Voyager image of saturn with the limb and rings overlain. #
#  If this example does not work, then your OMINAS_DIR variable               #
#  may not be set correctly.                                                  #
#-----------------------------------------------------------------------------#
NV_CONFIG=$OMINAS_DIR/config
export NV_CONFIG
NV_FTP_DETECT=$NV_CONFIG/tab/filetype_detectors.tab
export NV_FTP_DETECT
NV_IO=$NV_CONFIG/tab/io.tab
export NV_IO
NV_SPICE=$NV_CONFIG/spice
export NV_SPICE
NV_TRANSLATORS=$NV_CONFIG/tab/translators.tab
export NV_TRANSLATORS
NV_TRANSFORMS=$NV_CONFIG/tab/transforms.tab
export NV_TRANSFORMS
NV_SPICE_KER=:
export NV_SPICE_KER
NV_INS_DETECT=$NV_CONFIG/tab/instrument_detectors.tab
export NV_INS_DETECT

#-----------------------------------------------------------------------------------#
# DEMO configuration: 																#
#  This is the default OMINAS configuration.  It is just enough to make the 		#
#  demo scripts work.																#
#-----------------------------------------------------------------------------------#
OMINAS_DEMO=$OMINAS_DIR/demo
export OMINAS_DEMO
#NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_DEMO}/data/translators.tab
#export NV_TRANSLATORS
#NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_DEMO}/data/transforms.tab
#export NV_TRANSFORMS
#NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_DEMO}/data
#export NV_SPICE_KER
#NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_DEMO}/data/instrument_detectors.tab
#export NV_INS_DETECT

#-----------------------------------------------------------------------------------#
# 	These variables point to the directories containing the SPICE kernels			#
# 	required for the demo scripts.  You'll probably want to install a more			#
# 	comprehensive set of kernels elsewhere, in which case you would replace			#
# 	these locations with yours, and comment out the above demo configurations 		#
# 	(see below).																	#
#-----------------------------------------------------------------------------------#
NV_SPICE_PCK=$OMINAS_DIR/demo/data/kernels/pck/
export NV_SPICE_PCK
NV_SPICE_FK=$OMINAS_DIR/demo/data/kernels/fk/
export NV_SPICE_FK
NV_SPICE_IK=$OMINAS_DIR/demo/data/kernels/ik/
export NV_SPICE_IK
NV_SPICE_SCK=$OMINAS_DIR/demo/data/kernels/sck/
export NV_SPICE_SCK
NV_SPICE_LSK=$OMINAS_DIR/demo/data/kernels/lsk/
export NV_SPICE_LSK
NV_SPICE_CK=$OMINAS_DIR/demo/data/kernels/ck/
export NV_SPICE_CK
NV_SPICE_SPK=$OMINAS_DIR/demo/data/kernels/spk/
export NV_SPICE_SPK
NV_SPICE_XK=$NV_SPICE/
export NV_SPICE_XK

#-----------------------------------------------------------------------------------#
# Generic Kernels:                                                                  #
#  The default OMINAS configuration also will set up the generic kernels. These     #
#  kernels can be used to supplement limited data sets, such as the Voyager SPICE   #
#  kernels.                                                                         #
#-----------------------------------------------------------------------------------#
NV_SPICE_PCK=${NV_SPICE_PCK}:${SPICE_KER}/pck/
export NV_SPICE_PCK
NV_SPICE_FK=${NV_SPICE_FK}:${SPICE_KER}/fk/
export NV_SPICE_FK
NV_SPICE_LSK=${NV_SPICE_LSK}:${SPICE_KER}/lsk/
export NV_SPICE_LSK
NV_SPICE_SPK=${NV_SPICE_SPK}:${SPICE_KER}/spk/
export NV_SPICE_SPK
NV_SPICE_DSK=${SPICE_KER}/dsk/
export NV_SPICE_DSK

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the ring catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
NV_RING_DATA=$OMINAS_DIR/config/rings/
export NV_RING_DATA

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the orbit catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
NV_ORBIT_DATA=$OMINAS_DIR/config/orb/
export NV_ORBIT_DATA

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the station catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
NV_STATION_DATA=$OMINAS_DIR/config/stn/
export NV_STATION_DATA
