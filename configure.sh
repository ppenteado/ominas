#!/usr/bin/env bash
# configure.sh: OMINAS auto-configuration script
# If you are looking in here, something has gone wrong...

#------------------------------------------------------------------------#
# Want compatibility with your UNIX environment?                         #
# This configuration script is not POSIX compliant. There are several    #
# features which may fail on certain shells. The script must be run as   #
# a source and MAY work with other shells (certainly not the C shell)    #
# if the 'setting' variable is adjusted to the startup file for your     #
# shell (e.g., ksh must change these lines to '.profile' and '.kshrc')   #                                                  
#------------------------------------------------------------------------#

yes="INSTALLED"
no="NOT INSTALLED"
st="SET"
ns="NOT SET"
shtype="sh"

#------------------------------------------------------------------------#
# Configure will attempt to detect whether it is being run from its      #
# own directory. The directory is automatically changed if the test      #
# fails, and changed back at the end of execution.                       #
#------------------------------------------------------------------------#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test $DIR != $PWD && (printf "Warning: configuration should  be run from the OMINAS directory\n"; 
	cd $DIR;
	cdflag=true)

trap $(/bin/rm -f paths.pro; test $cdflag && cd $OLDPWD) EXIT

#------------------------------------------------------------------------#
# The type of bash settings file is detected. Configure requires use     #
# either '.bash_profile' or '.bashrc'. In general, bash_profile is       #
# used for login shells and bashrc is used for non-interactive shell     #
# sessions. If neither settings file is detected, bash_profile is used   #
# by default (this causes a new file to be made).                        #
#------------------------------------------------------------------------#
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
	# EXTRACT -----------------------------------------------------------#
	#    Extracts files of (almost) any archive file type.               #
	#    Arg 1 -> File to be extracted                                   #
	#    Issues: Files such as icy.tar.Z, the archive for the NAIF       #
	#    Icy toolkit will not break this function, but will two          #
	#    passes.                                                         #
	#    Note: No longer used. OMINAS is generally packaged as a git     #
	#    repository, which extracts itself. Also, this script is con-    #
	#    tained within the ominas directory...                           #
	#--------------------------------------------------------------------#
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
	# PACKAGE STATUS ----------------------------------------------------#
	#    Determines whether or not a mission package is installed.       #
	#    Arg 1 -> Name of the package to be checked                      #
	#    Checks the NV_TRANSLATORS environment variable, and deter-      #
	#    mines if the named package is contained in the list of          #
	#    directories. Returns an "INSTALLED" or "NOT INSTALLED" status.  #
	#--------------------------------------------------------------------#
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

function ppkg()
{
	# PARSE PACKAGE -----------------------------------------------------#
	#    Parses a numerical argument specifying the mission package.     #
	#    Arg 1 -> Numerical value to be parsed                           #
	#--------------------------------------------------------------------#
	script="ominas_env_${mis[$1-1]}.$shtype"
	pkins $script
}

function dins()
{
	# INSTALL DATA ------------------------------------------------------#
	#    Set a data package to the path.                                 #
	#    Arg 1 -> Name of the data package to be added to the path.      #
	#    Checks if the data package has already been written to the      #
	#    bash settings file, if it has, it will check if you would       #
	#    like to overwrite before prompting you for the directory.       #
	#    if you don't know, it will attempt to find it for you.          #
	#--------------------------------------------------------------------#
	if grep -q "NV_${Data[$1-5]}_DATA.*" ${setting}; then
		printf "Warning: ${Data[$1-5]} data files appear to already be set at this location:\n"
		eval echo \$NV_${Data[$1-5]}_DATA
		read -rp "Would you like to overwrite this location (y/n)? " ans
		case $ans in 
		[Yy]*)
			grep -v "NV_${Data[$1-5]}_DATA.*" $setting >$HOME/temp
			mv $HOME/temp $setting	;;
		*)
			return 1	
		esac
	fi		
	read -rp "Please enter the data or star catalog path (if not known, press enter): " datapath
	if ! [ -d $datapath ]; then
		printf "Attempting to automatically find data location...\n"
		dirlist=()
 		while IFS= read -r -d $'\0'; do
			dirlist+=("$REPLY")
		done < <(find $HOME -type d -iname ${Data[$1-5]} -print0 2>/dev/null)
		printf '%s\n' "${dirlist[@]}" | nl
		if [ -z ${dirlist[0]} ]; then
			printf "Warning: directory not found\n" 1>&2
			return 2
		fi
		read -r -p "Please type the number of the matching directory:  " match
		datapath=${dirlist[$match]}
	fi

	echo "NV_${Data[$1-5]}_DATA=$datapath; export NV_${Data[$1-5]}_DATA" >>$setting
}

function pkins()
{
	# INSTALL PACKAGE ---------------------------------------------------#
	#    Install the name mission package to bash_profile.               #
	#    Arg 1 -> Name of package to be installed                        #
	#    Checks if the named package is already written to the bash      #
	#    settings file before writing a new line.                        #
	#--------------------------------------------------------------------#
	if ! grep -q $1 $setting; then
		echo "source ${OMINAS_DIR}/config/$1" >> $setting
		printf "Installed package: $1\n"
	fi
}

printf "The setup will guide you through the installation of OMINAS\n"

if [ -z ${OMINAS_DIR+x} ]; then
# NOTE: OMINAS is available in repository form. Extraction is no longer needed
#	printf "Unpacking OMINAS tar archive...\n"
#	ext ominas_ringsdb_*.tar.gz
# DIR is set on line 25 and is the absolute path to the configure.sh script
	OMINAS_DIR=$DIR
	echo "OMINAS_DIR=$OMINAS_DIR; export OMINAS_DIR" >> $setting
fi

printf "OMINAS files located in $OMINAS_DIR\n"

# Ascertain the status of each package (INSTALLED/NOT INSTALLED) or (SET/NOT SET)
demost=`pkst ${OMINAS_DIR}/demo`
declare -a mis=("cas" "gll" "vgr" "dawn")
declare -a Data=("SEDR" "TYCHO" "SAO" "GSC")
for ((d=0; d<${#mis[@]}; d++));
do
	mstatus[$d]="`pkst ${OMINAS_DIR}/config/${mis[$d]}/`"
	if grep -q NV_${Data[$d]}_DATA $setting; then
		dstatus[$d]=$st
	else
		dstatus[$d]=$ns
	fi
done

# Print the configuration list with all statuses to the tty's stdout

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

read -r -p "Modify Current OMINAS configuration (exit/no/{yes=all} 1 2 ...)?  " ans

for num in $ans
do
	case $num in
		exit)
				return 0 	;;
		[Yy]*)
				pkins ominas_env_def.sh
				ppkg 1
				ppkg 2
				ppkg 3
				ppkg 4 	;;
		[Nn]*)
				break 		;;
		[1234])
				pkins ominas_env_def.sh
				ppkg $num 	;;
		[5678])
				pkins ominas_env_def.sh
				dins $num 	;;
		*)
				printf "Error: Invalid package or catalog specified\n" 1>&2
    esac
done

test "$1" == "-c" &&
for f in ./ominas_env_*.sh
do
	printf "Installing custom package $f...\n"
	pkins $f
done

#------------------------------------------------------------------------#
# Writes an IDL script to check if the IDL path has been written. If     #
# it has not, the path to the OMINAS directory will be written in the    #
# IDL_PATH, inside of IDL.                                               #
#------------------------------------------------------------------------#

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

printf "Setup has completed. It is recommended to restart your terminal session before using OMINAS.\n"