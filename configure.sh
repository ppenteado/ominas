#!/usr/bin/env bash
# configure.sh

yes="INSTALLED"
no="NOT INSTALLED"
nf="NOT FOUND"
shtype="sh"

shopt -s extglob

echo "Detecting .bash_profile..."
if [ -f ~/.bash_profile ]; then
	echo ".bash_profile detected!"
	setting="$HOME/.bash_profile"
else
	echo "Not present!"
	echo "Detecting .bashrc..."
	if [ -f ~/.bashrc ]; then
		echo ".bashrc detected!"
		setting="$HOME/.bashrc"
	else
		echo "Not present! Making a new .bash_profile..."
		touch "$HOME/.bash_profile"
		setting="$HOME/.bash_profile"
	fi
fi

function ext()
{
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >ext<" 1>&2 ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

function pkst()
{
	# PACKAGE STATUS ----------------------------------------------------------#
	#	Checks to see if an OMINAS PACKAGE is installed by looking for its 	   #
	#	presence in the NV_TRANSLATORS environment variable. All packages 	   #
	# 	modify this variable.												   #
	#--------------------------------------------------------------------------#
	if [ -z ${NV_TRANSLATORS+x} ]; then
		echo "$no"
	else
		if [[ $NV_TRANSLATORS == *"$1"* ]]; then
			echo "$yes"
		else
			echo "$no"
		fi
	fi
}

function pkins()
{
    # PACKAGE INSTALL ---------------------------------------------------------#
    # 	Runs the installation script associated with the package.              #
    # 	.sh scripts should run in bash to avoid issues caused by using the     #
    # 	older POSIX shell.                                                     #
    #                                                                          #
    # 	Note that the filename is fed in to the function as two arguments,     #
    # 	the first is the name of the package (i.e, ominas_env_*), and the      #
    # 	second is the script file extension, which can be accepted as .sh,     #
    # 	.csh, and .tcsh                                                        #
    #--------------------------------------------------------------------------#

	script="ominas_env_${mis[$1-1]}.$shtype"
	dswb $script
}

function dins()
{
	if [ "${dstatus[$1-5]}" != $nf ]; then
		cat <<CMD >>$setting
NV_${Data[$1-5]}_DATA=${dstatus[$1-5]}
export NV_${Data[$1-5]}_DATA
CMD
	else
		echo "Can't add non-existent data to path!" 1>&2
	fi
}

function dswb()
{
	# DETECT if SCRIPT WRITTEN to .BASHrc/_profile ----------------------------#
	# 	The first argument is the script to check for in the bash settings	   #
	# 	file. The second argument specifies whether to check bashrc or		   #
	#	bash_profile (i.e, 1 or 2 respectively). If no second argument is 	   #
	#	specified, both files will be checked.								   #
	#	If the line is detected, then no action is taken. If the line is 	   #
	#	not present, then the line to run the script will be written to 	   #
	#	the settings file.													   #
	#--------------------------------------------------------------------------#

	if [ -z "`grep "$1" "$setting"`" ]; then
		echo "source ${OMINAS_DIR}/config/$1" >> $setting
		echo "Installed package: $1"
	fi
}

echo "The setup will guide you through the installation of OMINAS"

#-------------------------------------------------------------------#
# Unpacking the OMINAS archive is the first step. In general,  		#
# OMINAS and other packages may be compressed in any number of		#
# ways, so for compatibility, the function extract() is used.  		#
#															   		#
# By default, the extraction is verbose.					   		#
#-------------------------------------------------------------------#

if [ -z ${OMINAS_DIR+x} ]; then
	echo "Unpacking OMINAS tar archive..."
	ext ominas_ringsdb_*.tar.gz
	OMINAS_DIR="$(find `pwd` ./ -type d -name "ringsdb" | grep -m 1 "ringsdb")"
	echo "OMINAS_DIR=$OMINAS_DIR; export OMINAS_DIR" >> $setting
fi

echo "OMINAS files located in $OMINAS_DIR"

demost="`pkst ${OMINAS_DIR}/demo`"
declare -a mis=("cas" "gll" "vgr" "dawn")
declare -a Data=("SEDR" "TYCHO" "SAO" "GSC")
for ((d=0; d<${#Data[@]}; d++));
do
	mstatus[$d]="`pkst ${OMINAS_DIR}/config/${mis[$d]}/`"

	dstatus[$d]="`find $HOME/ -type d -iname "${Data[$d]}" 2>/dev/null | grep -m 1 "${Data[$d]}"`"
	if [ "${dstatus[$d]}" == "" ]; then
		dstatus[$d]=$nf
	fi
done

cat <<PKGS
	Current OMINAS configuration settings
Required:
	Default  . . . . . . . . . . . . . . . . . $demost
Mission Packages:
	1) Cassini . . . . . . . . . . . . . . . . ${mstatus[0]}
	2) Galileo . . . . . . . . . . . . . . . . ${mstatus[1]}
	3) Voyager . . . . . . . . . . . . . . . . ${mstatus[2]}
	4) Dawn  . . . . . . . . . . . . . . . . . ${mstatus[3]}
Data:
	5) SEDR image data . . . . . . . . . . . . ${dstatus[0]}
	6) TYCHO star catalog  . . . . . . . . . . ${dstatus[1]}
	7) SAO star catalog  . . . . . . . . . . . ${dstatus[2]}
	8) GSC star catalog  . . . . . . . . . . . ${dstatus[3]}
PKGS

printf "Modify Current OMINAS configuration (exit/no/{yes=all} 1 2 ...)?  "
read -r ans

for num in $ans
do
	case $num in
		exit)
				return 0 	;;
		y*|Y*)
				dswb ominas_env_def.sh
				pkins 1
				pkins 2
				pkins 3
				pkins 4 	;;
		n*|N*)
				break 		;;
		1|2|3|4)
				dswb ominas_env_def.sh
				pkins $num 	;;
		5|6|7|8)
				dswb ominas_env_def.sh
				dins $num 	;;
		*)
				echo "Error: Invalid package or catalog specified" 1>&2
    esac
done



#-----------------------------------------------------------------------#
# 	In this section, all custom packages which are contained in 		#
# 	the same top-level directory as OMINAS are unpacked and 	  		#
# 	installed, one at a time. This process is automatic, and 	  		#
# 	verbose by default.									      			#
#-----------------------------------------------------------------------#

if [[ "$1" == "-c" ]]; then
	for f in $(dirname "$0")/ominas_env_*.sh
	do
	    echo "Installing custom package $f..."
	    dswb $f
	done
fi


addpath=":+$OMINAS_DIR"
cat <<IDLCMD >paths.pro
path=pref_get('IDL_PATH')
IF STRPOS(path, '$addpath') EQ -1 THEN path=path+'$addpath'
pref_set, 'IDL_PATH', path, /commit
print, '$OMINAS_DIR added to IDL_PATH'
exit
IDLCMD

/Applications/exelis/idl85/bin/idl paths.pro

. $setting

echo "Setup has completed. It is recommended to restart your terminal session before using OMINAS."

trap $(/bin/rm -f paths.pro) EXIT
