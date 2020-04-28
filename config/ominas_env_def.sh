#!/bin/sh
# ominas_env_def.sh
#----------------------------------------------------------------------------#
# OMINAS default setup for sh 	                                             #
#                                                                            #
#  This script configures the environment for OMINAS.  If you do not use sh, #
#  then you'll need to set these variables using syntax appropriate          #
#  to your preferred shell.                                                  #
#                                                                            #
#  This file will is copied into ~/.ominas/config when you upgrade your      #
#  OMINAS installation, so you should copy it to another location before     #
#  customizing it for your system.                                           #
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
export OMINAS_OBJ=$OMINAS_DIR/obj


export NV_CONFIG=$OMINAS_DIR/config
export NV_FTP_DETECT=$NV_CONFIG/tab/filetype_detectors.tab
export NV_IO=$NV_CONFIG/tab/io.tab
export NV_SPICE=$NV_CONFIG/spice
export NV_TRANSLATORS=$NV_CONFIG/tab/translators.tab
export NV_TRANSFORMS=$NV_CONFIG/tab/transforms.tab
export NV_SPICE_KER=:
export NV_INS_DETECT=$NV_CONFIG/tab/instrument_detectors.tab

#echo "DFLAG=${DFLAG}"
unset NV_SAO_DATA
#export PG_MAPS=${NV_MAPS_DATA}
if [ "${DFLAG}" = 'true' ]; then
    #-----------------------------------------------------------------------------------#
    # DEMO configuration: 																#
    #  This is the default OMINAS configuration.  It is just enough to make the 		#
    #  demo scripts work.																#
    #-----------------------------------------------------------------------------------#
    export OMINAS_DEMO=$OMINAS_DIR/demo
    export NV_TRANSLATORS=${NV_TRANSLATORS}:${OMINAS_DEMO}/data/translators.tab
    export NV_TRANSFORMS=${NV_TRANSFORMS}:${OMINAS_DEMO}/data/transforms.tab
    export NV_SPICE_KER=${NV_SPICE_KER}:${OMINAS_DEMO}/data
    export NV_INS_DETECT=${NV_INS_DETECT}:${OMINAS_DEMO}/data/instrument_detectors.tab
    export NV_SAO_DATA=$OMINAS_DIR/demo/data/
    
    #-----------------------------------------------------------------------------------#
    # 	These variables point to the directories containing the SPICE kernels	    	#
    # 	required for the demo scripts.  You'll probably want to install a more   		#
    # 	comprehensive set of kernels elsewhere, in which case you would replace	    	#
    # 	these locations with yours, and comment out the above demo configurations   	#
    # 	(see below).								    								#
    #-----------------------------------------------------------------------------------#
    export DEMO_SPICE_PCK=$OMINAS_DIR/demo/data/kernels/pck/
    export DEMO_SPICE_FK=$OMINAS_DIR/demo/data/kernels/fk/
    export DEMO_SPICE_IK=$OMINAS_DIR/demo/data/kernels/ik/
    export DEMO_SPICE_SCK=$OMINAS_DIR/demo/data/kernels/sck/
    export DEMO_SPICE_LSK=$OMINAS_DIR/demo/data/kernels/lsk/
    export DEMO_SPICE_CK=$OMINAS_DIR/demo/data/kernels/ck/
    export DEMO_SPICE_SPK=$OMINAS_DIR/demo/data/kernels/spk/
    export DEMO_SPICE_XK=$NV_SPICE/
    export NV_MAPS_DATA=$OMINAS_DATA/MAPS
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
	export GEN_SPICE_PCK=${pool}/pck/
	export GEN_SPICE_FK=${pool}/fk/
	export GEN_SPICE_LSK=${pool}/lsk/
	export GEN_SPICE_SPK=${pool}/spk/
	export GEN_SPICE_DSK=${pool}/dsk/
fi

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the array catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
export NV_ARRAY_DATA=$OMINAS_DIR/lib/arr/dat/

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the ring catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
export NV_RING_DATA=$OMINAS_DIR/lib/rings/

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the orbit catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
export NV_ORBIT_DATA=$OMINAS_DIR/lib/orb/

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# This variable points to the location of the station catalogs, which are
# provided in the default OMINAS installation.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
export NV_STATION_DATA=$OMINAS_DIR/lib/stn/dat/

