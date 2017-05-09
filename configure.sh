#!/bin/echo Should be run as: source
#!/usr/bin/env bash
# configure.sh: OMINAS auto-configuration script

# USAGE -----------------------------------------------------------------#
# This script sets the environment needed to run OMINAS. To use this     #
# installer, enter the following command at the terminal:                #
#      source configure.sh                                               #
#                                                                        #
# This command should be run from the "ominas" directory, if that is     #
# not the current working directory, the script can be run with:         #
#      source relative/path/to/configure.sh                              #
#                                                                        #
# OPTIONS:                                                               #
#                                                                        #
#      -c   CUSTOM   If a custom mission package is to be installed,     #
#                    name the script ominas_env_<mission name>.sh and    #
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
#    installer (Recall: source configure.sh).                            #
#                                                                        #
# Q: Something is wrong, but I don't know what...                        #
# A: If there is an unknown error with the configuration, run the        #
#    uninstaller with the command:                                       #
#                 source uninstall.sh                                    #
#    Then re-run the the installer (Recall: source configure.sh)         #
#                                                                        #
#------------------------------------------------------------------------#


# COMPATIBILITY ---------------------------------------------------------#
# This configuration script is not POSIX compliant. There are several    #
# features which may fail on certain shells. The script must be run as   #
# a source and MAY work with other shells (certainly not the C shell)    #
# if the 'setting' variable is adjusted to the startup file for your     #
# shell in the section titled SETTINGS FILE DETECTION (e.g., ksh must    #
# change these lines to '.profile' and '.kshrc')                         #
#                                                                        #
# If nothing else works, you can attempt to install manually by enter-   #
# ing the following commands into your shell settings file:              #
#                                                                        #
# OMINAS_DIR=path/to/OMINAS; export OMINAS_DIR                           #
#                                                                        #
# #First, select whether you would like the demo functionality enabled   #
# #by setting the DFLAG variable to true if yes, false if no.            #
# DFLAG=<true/false>                                                     #
# source ${OMINAS_DIR}/config/ominas_env_def.sh path/to/GENERIC_KERNELS  #
#                                                                        #
# #Similarly, enter a line for each additional package you would like    #
# #to install. For Cassini:                                              #
# source ${OMINAS_DIR}/config/ominas_env_cas.sh path/to/CAS_KERNELS      #
#                                                                        #
# #Note that Cassini->cas Voyager->vgr, Galileo->gll, Dawn->dawn         #
#------------------------------------------------------------------------#

shtype="sh"
ins_ominas_env_def=''
ins_c_0=''
inst_SAO=''
yes="CONFIGURED"
no="NOT CONFIGURED"
st="CONFIGURED"
ns="NOT CONFIGURED"
cwd=$PWD

#------------------------------------------------------------------------#
# Configure will attempt to detect whether it is being run from its      #
# own directory. The directory is automatically changed if the test      #
# fails, and changed back at the end of execution.                       #
#------------------------------------------------------------------------#
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test $DIR != $PWD && 
	(printf "Warning: configuration should  be run from the OMINAS directory\n"; 
	cd $DIR;
	cdflag=true)

trap `/bin/rm -f paths.pro; test $cdflag && (cd $cwd)` \
    EXIT

# SETTINGS FILE DETECTION -----------------------------------------------#
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
if [ ! -z ${IDL_PATH}+x ]; then
  if [ -f ~/.bashrc ]; then
    if grep --quiet IDL_PATH ~/.bashrc; then
      idlpathfile="$HOME/.bashrc"
    fi
  fi
  if [ ! ! -z ${IDL_PATH}+x ]; then
    if [ -f ~/.bash_profile ]; then
      if grep --quiet IDL_PATH ~/.bash_profile; then
        idlpathfile="$HOME/.bash_profile"
      else
        idlpathfile="$HOME/.profile"
      fi
    fi
  fi
fi


if [ "$IDL_DIR" = "" ]; then
        idl=`which idl`
        idlbin=$idl
        if [ "$idl" = "" ]; then
          read -rp "IDL not found. Please enter the location of your IDL installation (such as /usr/local/exelis/idl85): " idldir
          IDL_DIR="$idldir"
          export IDL_DIR
          printf "Using IDL from $IDL_DIR\n"
          idlbin=$IDL_DIR/bin/idl
        else
          printf "Using IDL at $idl\n"
        fi
else
        printf "IDL_DIR found, $IDL_DIR, using it\n"
        idlbin=$IDL_DIR/bin/idl
fi
export idlbin
ominassh="$HOME/.ominas/ominas_setup.sh"
usersh=$setting
setting=$ominassh
osetting="$HOME/.ominas/ominas_setup_old.sh"
if [ ! -d "$HOME/.ominas" ]; then
  printf "Creating ~/.ominas directory\n"
  mkdir $HOME/.ominas
else
  printf "~/.ominas directory already exists\n"
fi
if [ ! -d "$HOME/ominas_data" ]; then
  printf "Creating ~/ominas_data directory\n"
  mkdir $HOME/ominas_data
else
  printf "~/ominas_data directory already exists\n"
fi
if [ ! -e ${setting} ]; then
  echo "#!/usr/bin/env bash" > ${setting} 
fi
#if [ -e "$setting" ]; then
#  cp -av $setting $osetting
#else
#  touch $osetting
#fi

#echo "#!/usr/bin/env bash" > $setting

function ext()
{
	# EXTRACT -----------------------------------------------------------#
	#    Extracts files of (almost) any archive file type.               #
	#    Arg 1 -> File to be extracted                                   #
	#    Issues: Files such as icy.tar.Z, the archive for the NAIF       #
	#    Icy toolkit will not break this function, but will require      #
	#    two passes.                                                     #
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
            *.Z)         uncompress -f $1   ;;
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
        #echo $1
        #echo $NV_TRANSLATORS
	if [ -z ${NV_TRANSLATORS+x} ]; then
		echo "$no"
	else
                #echo "$1"
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
	script="ominas_env_${mis[$1]}.$shtype"
	case ${mis[$1]} in 
		"cas")
			kername="CASSINI"
                        longname="Cassini"	;;
		"gll")
			kername="GLL"
                        longname="Galileo"	;;
		"vgr")
			kername="VOYAGER"
                        longname="Voyager"	;;
		"dawn")
			kername="DAWN"
                        longname="Dawn"	;;
		*)
	esac
	pkins $script $kername $longname $1
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
	mnum=$1
	dat=${Data[$mnum]}
	if grep -q "export NV_${dat}_DATA" ${setting}; then
                if [ ${ominas_auto} == 1 ] ; then
                  return 1
                fi 
		printf "Warning: $dat data files appear to already be set at this location:\n"
                eval echo \$NV_${dat}_DATA
                tmp=`grep "export NV_${dat}_DATA" $setting`
                IFS='=' read -ra tmpa <<< "$tmp"
		#read -rp "Would you like to overwrite this location (y/n)? " ans
                if [ ${ominas_auto_u} != 1 ] ; then
                  read -rp "Would you like to uninstall $dat from this location (y/n)[n]? " ans
                else
                  ans=y
                fi
		case $ans in 
		[Yy]*)
                        #echo "!path+=':./util/downloader'& delete_ominas_files,'${tmpa[1]}' & exit"
                        $idlbin -e "!path+=':'+file_expand_path('./util/downloader')+':'+file_expand_path('./util/')& delete_ominas_files,'${tmpa[1]}',conf=${ominas_auto_u} & exit"
                        
                        unset inst[${1}]
                        return 1;;
			#grep -v "NV_${dat}_DATA.*" $setting >$HOME/temp
			#mv $HOME/temp $setting	;;
		*)
			#return 1
                        echo ''
                        return 1;;
		esac
        else
         if [ ${ominas_auto_u} == 1 ] ; then
           return 1
         fi
	fi
        if [ ${ominas_auto} == 1 ] ; then
          echo "Auto option selected in the main menu; will download and place the $dat data at ~/ominas_data/${dat}"
          datapath=~/ominas_data/${dat}
          datapath=`eval echo ${datapath}`
          if ! ./download_$dat.sh ${datapath} ; then
            unset inst[${1}]
            return 1
          fi
        else
          read -rp "Do you need to download the $dat data? [y]" ansk
          if [[ -z "${ansk// }" ]]; then
            ansk=y
          fi
          case $ansk in
           [Yy]*)
             read -rp "Please enter the location where the downloaded ${dat} data will be placed: [~/ominas_data/${dat}]" datapath
             if [ -z ${datapath} ] ; then
               datapath=~/ominas_data/${dat}
             fi
             datapath=`eval echo ${datapath}`
             if ! ./download_$dat.sh ${datapath} ; then
               unset inst[${1}]
               return 1
             fi ;;
           *)
	     read -rp "Please enter the path to $dat (if not known, press enter): " datapath
          esac 
        fi
        datapath=`eval echo ${datapath}`
	if ! [[ -d $datapath ]]; then
		#setdir $dat
                echo ""
	fi
        #echo "args: ${1}"
        inst[${1}]=${datapath}
        dins=${datapath}
	#echo "NV_${dat}_DATA=$datapath; export NV_${dat}_DATA" >>$setting
}

function pkins()
{
	# INSTALL PACKAGE ---------------------------------------------------#
	#    Install the name mission package to bash_profile.               #
	#    Arg 1 -> Name of package to be installed                        #
	#    Arg 2 -> Name of the kernel package name                        #
	#    Checks if the named package is already written to the bash      #
	#    sett  ings file before writing a new line.                        #
	#--------------------------------------------------------------------#
	#if [[ $1 == "ominas_env_def.$shtype" ]] && [[ $2 == $no ]]; then
		#read -rp "Would you like to install the demo package? " ans
		#case $ans in
		#	[Yy]*)
		#		# DFLAG sets the condition for the demo package environment
		#		# variables to be set in ominas_env_def.sh
		#		dstr="DFLAG=true; "		;;
		#	*)
		#		dstr="DFLAG=false; "
		#		printf "Demo package will not be installed...\n"
		#esac
        if [[ $1 == "ominas_env_def.$shtype" ]]; then
                if [[ "$2" == "$no" ]]; then
                  printf "Settiing OMINAS Core...\n"
                fi
                pstr="source ${OMINAS_DIR}/config/$1"
                if [[ "$3" == "coreu" ]] ; then
                  if [ ${ominas_auto} == 1 ] ; then
                    return 1
                  fi
#                pstr="source ${OMINAS_DIR}/config/$1"
                  if grep -q $1 ${setting}; then
                    if [ ${ominas_auto_u} != 1 ] ; then
                      read -rp "Would you like to uninstall the OMINAS core (y/n)[n]? " ans
                    else
                      ans="y"
                    fi
                    case $ans in
                    [Yy]*)
                          pstr="unset NV_TRANSLATORS"
                          unset NV_TRANSLATORS ;;
                    *)
                      return 1 ;;
                    esac
                  fi
                fi
                ins_ominas_env_def=${pstr}
	fi
        if [[ ! $1 == "ominas_env_def.$shtype" ]]; then
          if grep -q ${1} ${setting}; then
            if [ ${ominas_auto} == 1 ] ; then
              return 1
            fi
            loc=(`grep ${1} ${setting}`)
            echo "${3} seems to be already installed at ${loc[2]}"
            if [ ${ominas_auto_u} != 1 ] ; then
              read -rp "Would you like to uninstall ${3} (y/n)[n]? " ans
            else
              ans="y"
            fi
            #echo "1 ${1} 2 ${2} 3 ${3} 4 ${4}"
            case $ans in
                [Yy]*)
                     #echo "!path+=':./util/downloader'& delete_ominas_files,'${loc[2]}' & exit"
                     #$idlbin -e "!path+=':./util/downloader'& delete_ominas_files,'${loc[2]}',conf=${ominas_auto_u} & exit"
                     $idlbin -e "!path+=':'+file_expand_path('./util/downloader')+':'+file_expand_path('./util/')& delete_ominas_files,'${loc[2]}',conf=${ominas_auto_u} & exit"

                     #unset insp[${3}]
                     #unset ins[${3}]
                     insp[${4}]=' '
                     ins[${4}]=' '
                     #echo "${insp}"
                     #export insp
                     #export ins
                     return 1 ;;

                    *)
                     ins[${4}]=`grep ${1} ${setting}`
                     insp[${4}]=${loc[2]}
                     return 1;;
            esac
            echo "${insp[${4}]}"
          else
            if [ ${ominas_auto_u} == 1 ] ; then
              return 1
            fi
          fi
          printf "Installing package $1...\n"
          dstr=""
	  #read -rp "Would you like to add the $3 kernels to the environment? " ans
	  #case $ans in
	#	[Yy]*)

                      if [ ${ominas_auto} == 1 ] ; then
                        echo "Auto option selected in the main menu; will download and place the $3 kernels at ~/ominas_data/${3}"
                        datapath=~/ominas_data/${3}
                        datapath=`eval echo ${datapath}`
                        if ! ./download_$2.sh ${datapath}; then
                          unset insp[${4}]
                          unset ins[${4}]
                          return 1
                        fi
                        pstr="${dstr}source ${OMINAS_DIR}/config/$1 ${datapath}"
                      else
                        read -rp "Do you need to download the $3 kernels from PDS? [y]" ansk
                        if [[ -z "${ansk// }" ]]; then
                          ansk=y
                        fi
                        case $ansk in
                          [Yy]*)
                            read -rp "Please enter the location where the downloaded $3 kernel pool will be placed: [~/ominas_data/${3}]" datapath
                            if [ -z ${datapath} ] ; then
                              datapath=~/ominas_data/${3}
                            fi
                            datapath=`eval echo ${datapath}`
                            if ! ./download_$2.sh ${datapath}; then
                              unset insp[${4}]
                              unset ins[${4}]
                              return 1
                            fi
                            pstr="${dstr}source ${OMINAS_DIR}/config/$1 ${datapath}";;
                          *)
			    read -rp "Please enter the location of your existing $3 kernel pool: [~/ominas_data/${3}]" datapath
                            if [ -z ${datapath} ] ; then
                              datapath=~/ominas_data/${3}
                            fi
                            datapath=`eval echo ${datapath}`
			    if ! [[ -d $datapath ]]; then
			    	#setdir $2
                                echo ""
			    fi
			    pstr="${dstr}source ${OMINAS_DIR}/config/$1 ${datapath}";;
                        esac
                      fi
#		*)
#			pstr="${dstr}source ${OMINAS_DIR}/config/$1"
#	  esac
          ins[${4}]=${pstr}
          insp[${4}]=${datapath}
        fi
	dstr=""
	#grep -v ".*$1.*" $setting >$HOME/temp
	#mv $HOME/temp $setting
	#echo $pstr >> $setting
        ins_DEMO=${DFLAG}
}

function setdir() {
	# SET DIRECTORY -----------------------------------------------------#
	#    Set the location of a data set, in particular a kernel pool.    #
	#    Arg 1 -> Name of data pool to detect                            #
	#    Data pool location must have name of data type to be detected,  #
	#    for example the tycho catalog must be in a folder called        #
	#    tychox (x is based on the version number), but is not case      #
	#    sensitive.                                                      #
	#--------------------------------------------------------------------#
	searchdir=$HOME
	if ! [ -z ${2+x} ]; then searchdir=$2; fi
	printf "Attempting to automatically find data location from $searchdir...\n"
    dirlist=()
    while IFS= read -rd $'\0'; do
        dirlist+=("$REPLY")
    done < <(find $HOME -type d -iname $1 -print0 2>/dev/null)
    if [ -z ${dirlist[0]} ]; then
        printf "Warning: directory not found\n" 1>&2
        read -rp "Would you like to expand the search? (may take time) " ans
		case $ans in
		[Yy]*)
			setdir $1 "/" 	;;
		*)
			datapath=""
			return 2
		esac
    fi
    printf '%s\n' "${dirlist[@]}" | nl
    read -rp "Please type the number of the matching directory:  " match
	n=$(($match - 1))
	datapath=${dirlist[$n]}
}

function writesetting() {

echo "writing "$setting
if [ -e "$setting" ]; then
  cp -av $setting $osetting
else
  touch $osetting
fi
chmod a+rx $setting

echo "#!/usr/bin/env bash" > $setting

if [[ -n "$ins_ominas_env_def" ]]; then
  echo "export OMINAS_DIR=$OMINAS_DIR" >> $setting
fi
echo "export DFLAG=${DFLAG}" >> $setting
echo $ins_ominas_env_def >> $setting

for ((d=0; d<6; d++));
do
        dat=${Data[$d]}
        #echo "$d: ${inst[$d]}"
        #if grep -q NV_${Data[$d]}_DATA $setting; then
        if [ -z ${inst[$d]+x} ]  ;then
          #echo "${d}:0 ${inst[$d]}"
          echo "unset NV_${dat}_DATA" >>$setting
        else 
          #echo "$d: ${inst[$d]}"
          #echo "${d}:i ${inst[$d]}"
          
          echo "export NV_${dat}_DATA=${inst[$d]}" >>$setting
        fi
done
for ((d=0; d<6; d++));
do
        #echo "$d: ${insp[$d]}"
        #if grep -q NV_${Data[$d]}_DATA $setting; then
        if [ -z ${insp[$d]+x} ]  ;then
          echo "" #"${d}:0 ${ins[$d]}"
        else
          #echo "$d: ${ins[$d]}"
          #echo "${d}:i ${ins[$d]}"
          echo "${ins[$d]}" >>$setting
        fi
done



echo "done with writing ${setting}"

}

function icy() {

# ICY INSTALL -----------------------------------------------------------#
# Icy can be installed from the internet, or configured from a local     #
# copy. If NAIF kernels will not be used, then no action is taken.       #
# Icy is installed based on auto-detection of the OS.                    #
#------------------------------------------------------------------------#

if [ ${ominas_icyst} == 1 ] && [ ${ominas_auto} == 0 ]; then
  echo "Icy appears to be already configured:"
  echo ${ominas_icytest}
  if [ ${ominas_auto_u} != 1 ] ; then
    read -rp "Do you wish to uninstall Icy (y/n)[n]?"  ans
  else
    ans="y"
  fi
  case $ans in
    [Yy]*)
           $idlbin -e "!path+=':'+file_expand_path('./util/downloader')+':'+file_expand_path('./util/') & ominas_icy_remove & exit"
           if [ -e idlpathr.sh ]; then 
             source idlpathr.sh
           fi
           ominas_icyst=0
           icypath=''
           return 1;; 
        *) return 1;;
  esac
else
  if [ ${ominas_auto_u} == 1 ] ; then
    return 1
  fi
fi


printf "OMINAS requires the NAIF Icy toolkit to process SPICE kernels.\n"
#read -rp "Would you like to configure Icy for OMINAS? [y]" ans
ans=y
if [[ -z "${ans// }" ]]; then
 ans=y
fi
case $ans in
	[Yy]*)
		icyflag=true
                if [ ${ominas_auto} == 1 ] ; then
                  echo "Auto option selected in the main menu; will download and configure Icy at ~/ominas_data/icy"
                  ans=y
                else
		  read -rp "Would you like to install Icy from the internet now? [y]" ans
                fi
                if [[ -z "${ans// }" ]]; then
                  ans=y
                fi
		case $ans in
			[Yy]*)
				bits=$(uname -m); if [[ $bits == "x86_64" ]]; then bstr="64bit"; else bstr="32bit"; fi
				os=$(uname -s); if [[ $os == "Darwin" ]]; then ostr="MacIntel_OSX_AppleC"; else ostr="PC_Linux_GCC"; fi
				#curl -L "http://naif.jpl.nasa.gov/pub/naif/toolkit//IDL/${ostr}_IDL8.x_${bstr}/packages/icy.tar.Z" >"../icy.tar.Z"
                                echo "http://naif.jpl.nasa.gov/pub/naif/toolkit//IDL/${ostr}_IDL8.x_${bstr}/packages/icy.tar.Z" "~/ominas_data/icy.tar.Z"
                                #curl -L "http://naif.jpl.nasa.gov/pub/naif/toolkit//IDL/${ostr}_IDL8.x_${bstr}/packages/icy.tar.Z" > ~/ominas_data/icy.tar.Z
                                ldir=`eval echo ~/ominas_data/`
                                ./pp_wget "http://naif.jpl.nasa.gov/pub/naif/toolkit//IDL/${ostr}_IDL8.x_${bstr}/packages/icy.tar.Z" --localdir=${ldir}
                                owd=$PWD
				#cd ..
                                cd ~/ominas_data/
				cdflag=true
				#ext "icy.tar.Z"
				#ext "icy.tar"
                                echo "Extracting Icy source files..."
                                tar -xzf "icy.tar.Z"
				cd icy
				icypath=$PWD
                                echo "Compiling Icy..."
                                if [ ${ominas_auto} == 1 ] ; then
				  /bin/csh makeall.csh >& ~/.ominas/icy_make.log
                                else
                                 /bin/csh makeall.csh >& ~/.ominas/icy_make.log
                                fi
                                echo "Icy compiled. Log is at ~/.ominas/icy_make.log"
				cd $OMINAS_DIR	;;
			*)
				read -rp "Please enter the location of the Icy install directory [~/ominas_data/icy/]: " datapath
                                if [ -z ${datapath} ] ; then
                                  datapath=~/ominas_data/icy
                                fi
                                datapath=`eval echo ${datapath}`
				if ! [[ -d $datapath ]]; then
					#setdir "icy"
                                        echo ""
				fi
				icypath=$datapath
		esac	;;
	*)
		icyflag=false
		printf "Icy not configured for OMINAS.\n"
esac 

}

printf "The setup will guide you through the installation of OMINAS\n"

#if ! grep -q "OMINAS_DIR=.*; export OMINAS_DIR" ${setting}; then
# NOTE: OMINAS is available in repository form. Extraction is no longer needed
#	printf "Unpacking OMINAS tar archive...\n"
#	ext ominas_ringsdb_*.tar.gz
# DIR is set on line 82 and is the absolute path to the configure.sh script
	OMINAS_DIR=$DIR
#	echo "OMINAS_DIR=$OMINAS_DIR; export OMINAS_DIR" >> $setting
#fi

printf "OMINAS files located in $OMINAS_DIR\n"

function main() {


if [ -e "$setting" ]; then
  . $setting
fi


# Ascertain the status of each package (INSTALLED/NOT INSTALLED) or (SET/NOT SET)
corest=`pkst ${OMINAS_DIR}/config/tab/`
demost=$no
DFLAG="false"
#if [ ! -z $OMINAS_DEMO ]; then
if grep -q "export DFLAG=true" $setting; then
 demost="CONFIGURED"
 DFLAG="true"
fi

declare -a mis=("cas" "gll" "vgr" "dawn")
declare -a Data=("Generic_kernels" "SEDR" "TYCHO2" "SAO" "GSC" "UCAC4")
for ((d=0; d<${#mis[@]}; d++));
do
	#mstatus[$d]=`pkst ${OMINAS_DIR}/config/${mis[$d]}/`
        if grep -q "${OMINAS_DIR}/config/ominas_env_${mis[$d]}" $setting; then
          mstatus[$d]=$yes
          tmp=`grep "${OMINAS_DIR}/config/ominas_env_${mis[$d]}" $setting`
          read -r -a tmps <<< ${tmp}
          insp[$d]=${tmps[2]}
          ins[$d]=${tmp}
        else
          mstatus[$d]=$no
        fi
done
#export insp
#export ins
for ((d=0; d<${#Data[@]}; d++));
do
	if grep -q "export NV_${Data[$d]}_DATA" $setting; then
        #if [  -z {NV_${Data[$d]}_DATA+x} ]; then
		dstatus[$d]=$st
                tmp=`grep "export NV_${Data[$d]}_DATA" $setting`
                IFS='=' read -ra tmpa <<< "$tmp"
                inst[$d]=${tmpa[1]}
	else
                #echo "{NV_${Data[$d]}_DATA}"
		dstatus[$d]=$ns
	fi
done
#export inst
#$idlbin -e 'exit,status=strmatch(pref_get("IDL_DLM_PATH"),"*icy/lib*")'
ominas_icytest=`$idlbin -e "!path+=':'+file_expand_path('./util/downloader') & ominas_icy_test" # 2> /dev/null`
if [ $? == 0 ] ; then
  icyst='CONFIGURED'
  ominas_icyst=1
else
  icyst='NOT CONFIGURED'
  ominas_icyst=0
fi
echo "Icy: ${ominas_icytest}"
export ominas_icyst
# Print the configuration list with all statuses to stdout
cat <<PKGS
	Current OMINAS configuration settings
Required:
	1) OMINAS Core  . . . . . . . . . . . . .  $corest
           Contains the OMINAS code. If you select only one 
           of the other packages, this will be included.
Optional packages:
        2) Demo package . . . . . . . . . . . . .  $demost
           Contains the demo scripts and the data required 
           to run then.
           These files are always present (in ominas/demo), 
           this option is to set up the environment so that
           the demos can be run.
        3) SPICE Icy  . . . . . . . . . . . . . .  $icyst
           Library maintained by JPL's NAIF (Navigation and Ancillary
           Information Facility, https://naif.jpl.nasa.gov/naif/toolkit.html,
           required to use spacecraft / planetary kernel files.

Mission Packages:
           Kernels used for each mission's position and 
           pointing data. If you do not already have them,
           an option to download them from PDS will be provided.
           If you already have them, you will need to provide
           the path to your kernel files.
           Note: the NAIF Generic Kernels (one of the optional 
           data packages) are not required for the missions, they
           already contain a copy the subset of the generic kernel
           files they need.
	4) Cassini . . . . . . . . . . . . . . . . ${mstatus[0]}
           Subsetted, about 16 GB as of Dec/2016
	5) Galileo (GLL) . . . . . . . . . . . . . ${mstatus[1]}
           About 833 MB as of Dec/2016
	6) Voyager . . . . . . . . . . . . . . . . ${mstatus[2]}
           About 163 MB as of Dec/2016
	7) Dawn  . . . . . . . . . . . . . . . . . ${mstatus[3]}
           Subsetted, about 8 GB as of Jan/2017
Data:
        8) NAIF Generic Kernels . . . . . . . . .  ${dstatus[0]}
           About 22 GB as of Dec/2016
	9) SEDR image data . . . . . . . . . . . . ${dstatus[1]}
       10) TYCHO2 star catalog . . . . . . . . . . ${dstatus[2]}
           About 161 MB download, 665 MB unpacked
       11) SAO star catalog . . . . . . . . . . . ${dstatus[3]}
           About 19 MB download, 70 MB unpacked
       12) GSC star catalog . . . . . . . . . . . ${dstatus[4]}
       13) UCAC4 star catalog . . . . . . . . . . ${dstatus[5]}
           About 8.5 GB download
For more information, see
https://ppenteado.github.io/ominas_doc/demo/install_guide.html
PKGS

pr=1
while [ $pr == 1 ]; do
read -rp "Modify Current OMINAS configuration (Exit/Auto/Uninstall 1 2 ...)?  " ans
aans=($ans)
if [ "${aans[0]}" == "" ]; then
  aans[0]="null"
fi
ominas_auto=0
if [ ${aans[0]} == "auto" ] || [ ${aans[0]} == "a" ] || [ ${aans[0]} == "A" ]; then

  cat <<AUTOP

  You have selected the auto option for OMINAS setup.

  This option will download and configure every package, to their
default locations, without prompting for confirmation or install
directories. If data packages are not already present in the default
directories, they will be downloaded, which may take a long time and
several GB of disk space. If any files to be downloaded are already
present in their default location, their download will be skipped.


AUTOP

  read -rp "Proceed? [y]" ansy
  if [[ -z "${ansy// }" ]]; then
    ansy=y
  fi
  if [ ${ansy} == "y" ] || [ ${ansy} == "Y" ]; then
    ominas_auto=1
    ans="1 2 3 4 5 6 7 8 9 10 11 12 13"
  else
    ans="all"
  fi
fi
export ominas_auto

ominas_auto_u=0
if [ ${aans[0]} == "uninstall" ] || [ ${aans[0]} == "u" ] || [ ${aans[0]} == "U" ]; then

  cat <<AUTOP

  You have selected the auto option for uninstalling OMINAS.

  This option will uninstall every package from their current locations, 
without prompting for confirmation.


AUTOP

  read -rp "Proceed? [y]" ansy
  if [[ -z "${ansy// }" ]]; then
    ansy=y
  fi
  if [ ${ansy} == "y" ] || [ ${ansy} == "Y" ]; then
    ominas_auto_u=1
    ans="3 4 5 6 7 8 9 10 11 12 13 2 1"
  else
    ans="uall"
  fi
fi
export ominas_auto_u


pr=0
for num in $ans
do
  if [ $num == "2" ]; then
    if [ $DFLAG  == "true" ] && [ ${ominas_auto} == 0 ]; then
      DFLAG="false"
      demost="NOT CONFIGURED"
    else
      DFLAG="true"
      demost="CONFIGURED"
    fi
  fi
done
for num in $ans
do
	case $num in
		[eE]|exit)
                                pr=0
				return	3;;
		[1])            
                                pr=0
				pkins ominas_env_def.sh "${corest}" coreu
                                corest=${yes}
							;;
                [2])
                                pr=0
                                pkins ominas_env_def.sh "${corest}" demo
                                corest=${yes}
                                                        ;;
                [3])
                                pr=0
                                icy
                                                        ;;

		#[Nn]*)
		#		break 		;;
		[4567])
                                pr=0
				pkins ominas_env_def.sh "${corest}" $(($num-4))
                                corest=${yes}
				ppkg $(($num-4)) 	;;
		[89]|10|11|12|13)
                                pr=0
                                pkins ominas_env_def.sh "${corest}" $(($num-8))
                                corest=${yes}
				dins $(($num-8)) 	;;
                all)            pr=0;;
                uall)           pr=0;;
		*)
				printf "Error: Invalid package or catalog specified\n" 1>&2
                                pr=1;;
    esac
done


done

XIDL_DIR=$OMINAS_DIR/util/xidl/

test "$1" == ".*c.*" &&
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
#if [ $ominas_icyst == 1 ]; then
#  icyflag=true
   
#else
#  icyflag=false
#fi
cat <<IDLCMD >paths.pro
flag='$icyflag'
path=getenv('IDL_PATH') ? getenv('IDL_PATH') : PREF_GET('IDL_PATH')
;IF STRPOS(path, '$icypath') EQ -1 AND flag EQ 'true' THEN path=path+':+$icypath/lib/'
IF STRPOS(path, '$OMINAS_DIR') EQ -1 THEN path=path+':+$OMINAS_DIR'
IF STRPOS(path, '$XIDL_DIR') EQ -1 THEN path=path+':+$XIDL_DIR'
if getenv('IDL_PATH') then begin &\$ 
  openw,lun,'idlpath.sh',/get_lun &\$ 
  printf,lun,'export IDL_PATH="'+path+'"' &\$ 
  free_lun,lun &\$ 
endif else PREF_SET, 'IDL_PATH', path, /COMMIT
dlm_path=getenv('IDL_DLM_PATH') ? getenv('IDL_DLM_PATH') : PREF_GET('IDL_DLM_PATH')
;IF STRPOS(dlm_path, '$icypath') EQ -1 AND flag EQ 'true' THEN dlm_path=dlm_path+':+$icypath/lib/'
;if getenv('IDL_DLM_PATH') then begin &\$
;  openw,lun,'idlpath.sh',/get_lun,/append &\$ 
;  printf,lun,'export IDL_DLM_PATH="'+dlm_path+'"' &\$ 
;  free_lun,lun &\$ 
;endif else PREF_SET, 'IDL_DLM_PATH', dlm_path, /COMMIT
PRINT, '$OMINAS_DIR added to IDL_PATH'
!path+=':$OMINAS_DIR/util/:$OMINAS_DIR/util/downloader/'
idlastro_download,/auto
EXIT
IDLCMD

#if [ "$IDL_DIR" = "" ]; then
#        idl=`which idl`
#        idlbin=$idl
#        if [ "$idl" = "" ]; then
#          read -rp "IDL not found. Please enter the location of your IDL installation (such as /usr/local/exelis/idl85): " idldir
#          IDL_DIR="$idldir"
#          export IDL_DIR
#          printf "Using IDL from $IDL_DIR\n"
#          idlbin=$IDL_DIR/bin/idl
##          $IDL_DIR/bin/idl paths.pro
#        else
#          printf "Using IDL at $idl\n"
##          $idl paths.pro
#        fi
#else
#        printf "IDL_DIR found, $IDL_DIR, using it\n"
#        idlbin=$IDL_DIR/bin/idl
##        $IDL_DIR/bin/idl paths.pro
#fi
if [ ${corest} == ${yes} ]; then
  #$idlbin paths.pro
  
  $idlbin -e "!path+=':'+file_expand_path('./util/downloader')+':'+file_expand_path('./util/')& ominas_paths_add,'${icypath}'"
  if [ -e idlpath.sh ]; then
    cat idlpath.sh >> $idlpathfile
    rm idlpath.sh
  fi
else
  export OMINAS_DIR=''
  $idlbin -e "!path+=':'+file_expand_path('./util/downloader')+':'+file_expand_path('./util/')& ominas_paths_add,'${icypath}'"
fi
rm paths.pro

if [ -e idlpathr.sh ]; then
  #cat idlpathr.sh >> $idlpathfile
  rm idlpathr.sh
fi


writesetting
if [ -e "$setting" ]; then
  . $setting
fi
if [ ! -z ${IDL_PATH+x} ]; then
  . $idlpathfile
  printf "IDL PATH/IDL_DLM_PATH were written to $idlpathfile.\n"
fi
#writesetting
if grep -q ${setting} ${usersh} ; then
  echo "${usersh} already calls ${setting}"
else
  echo source $setting >> $usersh
fi
printf "OMINAS configuration was written to $usersh.\n"
return 0
}
echo " "
while [ 1 ]; do
  main
  if  [ $? == 3 ] ; then
    break
  fi
  
done

printf "Setup has completed. It is recommended to restart your terminal session before using OMINAS.\n"
printf "You may want to try some of the tutorials at https://ppenteado.github.io/ominas_doc/demo/\n"
