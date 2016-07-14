#!/usr/bin/env tcsh
# configure.csh

# Writing C shell scripts is literally the worst thing. I only made this terr-
# ible script because I was asked to by certain individuals who still use the
# C shell. If you want stability, and more options, for your OMINAS install,
# please use the bash installer.

set yes = "INSTALLED"
set no = "NOT INSTALLED"
set nf = "NOT FOUND"
set shtype = "csh"
set setting = "${HOME}/.cshrc"
set mis = ( "def" "cas" "gll" "vgr" "dawn" )
set Data = ( "SEDR" "TYCHO" "SAO" "GSC" )

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
PKGS

printf "Modify Current OMINAS configuration (exit/no/{yes=all} 1 2 ...)?  "
set ans = "$<"

foreach num ( $ans )
	switch ( $num )
		case exit:
				return 0; breaksw;
		case [Yy]*:
			foreach pkg ( $mis )
				set script = "ominas_env_$pkg.$shtype"
				if ( `grep "$script" $setting` == "" ) then
					echo "source ${OMINAS_DIR}/config/$script" >>& $setting
					echo "Installed package: $script"
				endif
			end
		breaksw;
		case [Nn]*:
				break; breaksw;
		case [1234]:
			# What's a function? I've never heard of such a thing...
			set script = "ominas_env_def.$shtype"
			if ( `grep "$script" $setting` == "" ) then
				echo "source ${OMINAS_DIR}/config/$script" >>& $setting
				echo "Installed package: $script"
			endif
			@ num++
			set script = "ominas_env_${mis[$num]}.$shtype"
			if ( `grep "$script" $setting` == "" ) then
				echo "source ${OMINAS_DIR}/config/$script" >>& $setting
				echo "Installed package: $script"
			endif
		breaksw;
		case [5678]:
			set script = "ominas_env_def.$shtype"
			if ( `grep "$script" $setting` == "" ) then
				echo "source ${OMINAS_DIR}/config/$script" >>& $setting
				echo "Installed package: $script"
			endif
			@ num -= 4
			set dstatus = `find $HOME/ -type d -iname ${Data[$num]} | grep -m 1 "${Data[$num]}"`
			echo $dstatus
			if ! ( $dstatus == "" ) then
				echo "setenv NV_${Data[$num]}_DATA $dstatus" >>& $setting
			else
				echo "Can't add non-existent data to path!"
			endif
		breaksw;
		default:
			echo "Error: Invalid package or catalog specified"
	endsw
end

printf "OMINAS requires the NAIF Icy toolkit to process SPICE kernels.\n"
printf "Would you like to install Icy now? "
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
		set datapath = $PWD
		csh makeall.csh
		cd $OMINAS_DIR
	breaksw;
	case [Nn]*:
		printf "Please enter the location of your Icy install folder: "
		set datapath = "$<"
	breaksw;
	default:
		break
	endsw
set icydir = $datapath

setenv XIDL_DIR		"$OMINAS_DIR/util/xidl"

set addpath = ":+$OMINAS_DIR"
set icypath = ":+$icydir"
set xidlpath = ":+$XIDL_DIR"
set idlfile="paths.bat"
cat <<IDLCMD >& $idlfile
path=pref_get('IDL_PATH')
IF STRPOS(path, '$addpath') EQ -1 THEN path=path+'$icypath'
IF STRPOS(path, '$icypath') EQ -1 THEN path=path+'$addpath'
IF STRPOS(path, '$xidlpath') EQ -1 THEN path=path+'$addpath'
pref_set, 'IDL_PATH', path, /commit
dlm_path=pref_get('IDL_DLM_PATH')
IF STRPOS(dlm_path, '$icypath') EQ -1 THEN dlm_path=dlm_path+'$icypath'
pref_set, 'IDL_DLM_PATH', dlm_path, /commit
print, '$OMINAS_DIR added to IDL_PATH'
exit
IDLCMD

onintr rmpaths

$IDL_DIR/idl/bin/idl $idlfile

source $setting

echo "Setup has completed. It is recommended to restart your terminal session before using OMINAS."

/bin/rm -f $idlfile

rmpaths:
/bin/rm -f $idlfile