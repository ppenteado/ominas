#!/bin/sh
# ominas_env_def.sh
#----------------------------------------------------------------------------#
# OMINAS default setup for sh 	                                             #
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

#echo "DFLAG=${DFLAG}"
if [ "${DFLAG}" = 'true' ]; then
    #-----------------------------------------------------------------------------------#
    # DEMO configuration: 																#
    #  This is the default OMINAS configuration.  It is just enough to make the 		#
    #  demo scripts work.																#
    #-----------------------------------------------------------------------------------#
    OMINAS_DEMO=$OMINAS_DIR/demo
    export OMINAS_DEMO
    NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_DEMO}/data/translators.tab
    export NV_TRANSLATORS
    NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_DEMO}/data/transforms.tab
    export NV_TRANSFORMS
    NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_DEMO}/data
    export NV_SPICE_KER
    NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_DEMO}/data/instrument_detectors.tab
    export NV_INS_DETECT
    
    #-----------------------------------------------------------------------------------#
    # 	These variables point to the directories containing the SPICE kernels	    	#
    # 	required for the demo scripts.  You'll probably want to install a more   		#
    # 	comprehensive set of kernels elsewhere, in which case you would replace	    	#
    # 	these locations with yours, and comment out the above demo configurations   	#
    # 	(see below).								    								#
    #-----------------------------------------------------------------------------------#
	DEMO_SPICE_PCK=$OMINAS_DIR/demo/data/kernels/pck/
	export DEMO_SPICE_PCK
	DEMO_SPICE_FK=$OMINAS_DIR/demo/data/kernels/fk/
	export DEMO_SPICE_FK
	DEMO_SPICE_IK=$OMINAS_DIR/demo/data/kernels/ik/
	export DEMO_SPICE_IK
	DEMO_SPICE_SCK=$OMINAS_DIR/demo/data/kernels/sck/
	export DEMO_SPICE_SCK
	DEMO_SPICE_LSK=$OMINAS_DIR/demo/data/kernels/lsk/
	export DEMO_SPICE_LSK
	DEMO_SPICE_CK=$OMINAS_DIR/demo/data/kernels/ck/
	export DEMO_SPICE_CK
	DEMO_SPICE_SPK=$OMINAS_DIR/demo/data/kernels/spk/
	export DEMO_SPICE_SPK
	DEMO_SPICE_XK=$NV_SPICE/
	export DEMO_SPICE_XK
fi

#-----------------------------------------------------------------------------------#
# Generic Kernels:                                                                  #
#  The default OMINAS configuration also will set up the generic kernels. These     #
#  kernels can be used to supplement limited data sets, such as the Voyager SPICE   #
#  kernels.                                                                         #
#-----------------------------------------------------------------------------------#

if ! [ -z ${NV_Generic_kernels_DATA+x} ]; then
	pool=${NV_Generic_kernels_DATA}
	if ! [ -d "${pool}/pck" ]; then pool="${pool}/kernels"; fi
	GEN_SPICE_PCK=${pool}/pck/
	export GEN_SPICE_PCK
	GEN_SPICE_FK=${pool}/fk/
	export GEN_SPICE_FK
	GEN_SPICE_LSK=${pool}/lsk/
	export GEN_SPICE_LSK
	GEN_SPICE_SPK=${pool}/spk/
	export GEN_SPICE_SPK
	GEN_SPICE_DSK=${pool}/dsk/
	export GEN_SPICE_DSK
fi

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the array catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
NV_ARRAY_DATA=$OMINAS_DIR/config/arr/dat/
export NV_ARRAY_DATA

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

XIDL_DIR="$OMINAS_DIR/util/xidl"
export XIDL_DIR
alias xidl="/bin/csh $XIDL_DIR/xidl.csh"
alias grim='xidl grim.bat +'
alias brim='xidl brim.bat +'
alias rim='xidl rim.bat +'
