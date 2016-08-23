#!/usr/bin/env csh
# configure.csh
# USAGE -----------------------------------------------------------------#
# This script sets the environment needed to run OMINAS. To use this     #
# installer, enter the following command at the (t)csh terminal:         #
#      source configure.csh                                              #
#                                                                        #
# This command should be run from the "ominas" directory, if that is     #
# not the current working directory, the script can be run with:         #
#      source relative/path/to/configure.csh                             #
#                                                                        #
# OPTIONS:                                                               #
#                                                                        #
#      -c   CUSTOM   If a custom mission package is to be installed,     #
#                    name the script ominas_env_<mission name>.csh and   #
#                    place it in the ominas directory.                   #
#                                                                        #
# ADDITIONAL NOTES:                                                      #
# WILL INSTALL:                                                          #
#      -> OMINAS core package                                            #
#      -> Mission packages (Optional)                                    #
#      -> NAIF Icy Toolkit (Optional) (Internet Connection Required)     #
#      -> Star Catalogs                                                  #
#      -> Voyager SEDR data                                              #
#                                                                        #
# A local copy of the following must be present to be configured for     #
# OMINAS:                                                                #
#      -> Star Catalogs (Download from CDS)                              #
#      -> Mission Kernel Pools (Download from NAIF or PDS)               #
#      -> Voyager SEDR data                                              #
#                                                                        #
# FAQ:                                                                   #
# Q: What should I do if I have data installed in a custom directory     #
#    and I misspell the path name?                                       #
# A: If you make a typo entering a path name, you can re-run the         #
#    installer (Recall: source configure.csh).                           #
#                                                                        #
# Q: Something is wrong, but I don't know what...                        #
# A: If there is an unknown error with the configuration, run the        #
#    uninstaller with the command:                                       #
#                 source uninstall.csh                                   #
#    Then re-run the the installer (Recall: source configure.csh)        #
#                                                                        #
#------------------------------------------------------------------------#


# WARNING ---------------------------------------------------------------#
# This script was written to the best of the programmer's ability, how-  #
# ever it is not as fully featured as the bash shell version of the      #
# auto-configuration script primarily due to limitations in the script-  #
# ing capabililties in the c shell. It is STRONGLY recommended to use    #
# the bash shell version of this installer (at least in a subshell of    #
# tcsh) rather than this version. It is provided for compatibility with  #
# C shell users.                                                         #
#                                                                        #
# If this auto-config script does not work properly, you can attempt to  #
# configure OMINAS manually by adding the following commands into the    #
# .cshrc file contained in your HOME folder:                             #
#                                                                        #
# setenv OMINAS_DIR     path/to/OMINAS                                   #
#                                                                        #
# #First, select whether you would like the demo functionality enabled   #
# #by setting the DFLAG variable to true if yes, false if no. The path   #
# #to the generic kernels is optional.                                   #
# set DFLAG = <true/false>                                               #
# source ${OMINAS_DIR}/config/ominas_env_def.csh path/to/GENERIC_KERNELS #
#                                                                        #
# #Similarly, enter a line for each additional package you would like    #
# #to install, and the kernel path is optional. For Cassini:             #
# source ${OMINAS_DIR}/config/ominas_env_cas.csh path/to/CAS_KERNELS     #
#                                                                        #
# #Note that Cassini->cas Voyager->vgr, Galileo->gll, Dawn->dawn         #
#------------------------------------------------------------------------#

set yes = "INSTALLED"
set no = "NOT INSTALLED"
set nf = "NOT FOUND"
set shtype = "csh"
set setting = "${HOME}/.cshrc"
set mis = ( "cas" "gll" "vgr" "dawn" )
set Data = ( "SEDR" "TYCHO2" "SAO" "GSC" "UCAC4" "UCACT" )

echo "The setup will guide you through the installation of OMINAS"

if ! ( $?OMINAS_DIR ) then
	# echo "Unpacking OMINAS tar archive..."
	# tar -xzvf ominas_ringsdb_*.tar.gz
	set rootdir = `dirname $0`
	set OMINAS_DIR=`cd $rootdir && pwd`
	echo "setenv OMINAS_DIR $OMINAS_DIR" >>& $setting
endif

echo "OMINAS files located in $OMINAS_DIR"


cat <<PKGS
	Current OMINAS configuration settings
Required:
	Default
Mission Packages:
	1) Cassini
	2) Galileo
	3) Voyager
	4) Dawn
Data:
	5) SEDR image data
	6) TYCHO star catalog
	7) SAO star catalog
	8) GSC star catalog
	9) UCAC4 star catalog
	10) UCACT star catalog
PKGS

printf "Modify Current OMINAS configuration (exit/no/{yes=all} 1 2 ...)?  "
set ans = "$<"

foreach num ( $ans )
	switch ( $num )
		case exit:
				return 0; breaksw;
		case [Yy]*:
			printf "Please enter the path to the generic_kernel pool (Enter to skip): "
			set gen_ker = "$<"
			set script = "ominas_env_def.$shtype $gen_ker"
			if ( `grep "$script" $setting` == "" ) then
				echo "source ${OMINAS_DIR}/config/$script" >>& $setting
				echo "Installed default package."
			endif
			foreach pkg ( $mis )
				printf "Please enter the path to the $pkg kernel pool (Enter to skip): "
				set spice_ker = "$<"
				set script = "ominas_env_$pkg.$shtype $spice_ker"
				if ( `grep "$script" $setting` == "" ) then
					echo "source ${OMINAS_DIR}/config/$script" >>& $setting
					echo "Installed package: $pkg"
				endif
			end
		breaksw;
		case [Nn]*:
				break; breaksw;
		case [1234]:
			# What's a function? I've never heard of such a thing...
			@ num -= 1
			printf "Please enter the path to the generic_kernel pool (Enter to skip): "
			set gen_ker = "$<"
			set script = "ominas_env_def.$shtype $gen_ker"
			if ( `grep "$script" $setting` == "" ) then
				echo "source ${OMINAS_DIR}/config/$script" >>& $setting
				echo "Installed default package."
			endif
			printf "Please enter the path to the ${mis[$num]} kernel pool (Enter to skip): "
			set spice_ker = "$<"
			set script = "ominas_env_${mis[$num]}.$shtype $spice_ker"
			if ( `grep "$script" $setting` == "" ) then
				echo "source ${OMINAS_DIR}/config/$script" >>& $setting
				echo "Installed package: $pkg"
			endif
		breaksw;
		case [56789]|10:
			@ num -= 4
			printf "Please enter the path to ${Data[$num]}: "
			set dstatus = "$<" 
			if ! ( -d $dstatus ) then set dstatus = `find $HOME/ -type d -iname ${Data[$num]} | grep -m 1 "${Data[$num]}"`
			if ! ( -d $dstatus ) then echo "Warning: could not find path to ${Data[$num]}"
			echo "Using $dstatus" 	
			echo "setenv NV_${Data[$num]}_DATA $dstatus" >>& $setting
		breaksw;
		default:
			echo "Error: Invalid package or catalog specified"
	endsw
end

printf "OMINAS requires the NAIF Icy toolkit to process SPICE kernels.\n"
printf "Would you like to install Icy now? (y/n/ press any other key to locate manually) "
set ans = "$<"

switch ( $ans )
	case [Yy]*:
		set bits = `uname -m`
		if ( $bits == "x86_64" ) then
			set bstr = "64bit"
		else
			set bstr = "32bit"
		endif
		set os = `uname -s`
		if ( $os == "Darwin" ) then
			set ostr = "MacIntel_OSX_AppleC"
		else 
			set ostr = "PC_Linux_GCC"
		endif

		curl "http://naif.jpl.nasa.gov/pub/naif/toolkit//IDL/${ostr}_IDL8.x_$bstr/packages/icy.tar.Z" >& "../icy.tar.Z"
		uncompress "icy.tar.Z"
		tar xvf "icy.tar"
		cd ../icy
		set icypath = $PWD
		csh makeall.csh
		cd $OMINAS_DIR
	breaksw;
	case [Nn]*:
		set icypath = ":"
	breaksw;
	default:
		printf "Please enter the location of your Icy install folder: "
		set icypath = "$<"
		set icyflag = 'true'
endsw

setenv XIDL_DIR		"$OMINAS_DIR/util/xidl"

set idlfile = "paths.bat"
cat <<IDLCMD >paths.pro
flag='$icyflag'
path=PREF_GET('IDL_PATH')
IF STRPOS(path, '$icypath') EQ -1 THEN path=path+':+$icypath'
IF STRPOS(path, '$OMINAS_DIR') EQ -1 THEN path=path+':+$OMINAS_DIR'
IF STRPOS(path, '$XIDL_DIR') EQ -1 THEN path=path+':+$XIDL_DIR'
PREF_SET, 'IDL_PATH', path, /COMMIT
dlm_path=PREF_GET('IDL_DLM_PATH')
IF STRPOS(dlm_path, '$icypath') EQ -1 THEN dlm_path=dlm_path+':+$icypath'
PREF_SET, 'IDL_DLM_PATH', dlm_path, /COMMIT
PRINT, '$OMINAS_DIR added to IDL_PATH'
EXIT
IDLCMD

onintr rmpaths

if ( "$IDL_DIR" == "" ) then
	setenv IDL_DIR	/usr/local/exelis/idl85 
endif
$IDL_DIR/bin/idl $idlfile

source $setting

echo "Setup has completed. It is recommended to restart your terminal session before using OMINAS."

/bin/rm -f $idlfile

rmpaths:
/bin/rm -f $idlfile