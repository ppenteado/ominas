#!/usr/bin/env bash
###############################################################################
# OMINAS Installation script
#
#  To install OMINAS, type:
#
#  source ./INSTALL.sh
#
#  This script will create the ominas setup directory $HOME/.ominas/ and
#  then start the OMINAS installer OMIN, which sets up the default 
#  configuration.  If you exit OMIN at this point, the demo configuration 
#  should be active and functional.  [[actually need to install maps and spice?]] 
#
#  OMIN can be run at any time to reconfigure your installation using the
#  'omin' shell alias.
#
#
#
#
#  Options:
#   -force		Force new installation even if one already exists.  
#			The current .ominas directory is renamed to 
#			.ominas-restore.  If there is already a directory by
#			that name, it is deleted.
#   -restore	 	Restore a configuration previously removed via -force, 
#			if one exists.  The current .ominas directory is 
#			copied to .ominas-restore.
#   -rm			Remove the current OMINAS installation.
#   -debug		Installation takes place in ~/.ominas-debug and
#			has no effect on a current OMINAS installation.
#
###############################################################################


#-------------------------------------------------------------------------#
# Verify this script is sourced.
#-------------------------------------------------------------------------#
usage="Usage: source INSTALL.sh <args>"
if [[ "$0" == *INSTALL.sh ]] ; then 
 printf "$usage\n"
 exit  
fi


#-------------------------------------------------------------------------#
# Get arguments.
#-------------------------------------------------------------------------#
for arg in $@; do
 if [[ $arg == -force ]] ; then force=1
 elif [[ $arg == -restore ]] ; then restore=1
 elif [[ $arg == -rm ]] ; then rm=1
 elif [[ $arg == -debug ]] ; then debug=1
 else 
   printf "Unrecognized argument: $arg.\n"
   return
 fi
done


#-------------------------------------------------------------------------#
# Address debug flag.
#-------------------------------------------------------------------------#
setup_dir=$HOME/.ominas/
if [ "$debug" == 1 ]; then 
#  yes|rm -r $HOME/.ominas-debug >& /dev/null
  setup_dir=$HOME/.ominas-debug
fi


#-------------------------------------------------------------------------#
# Abort if not in OMINAS top dir.
#-------------------------------------------------------------------------#
if [ ! -f "./module/module_init_ominas.pro" ]; then 
  printf "This script must be sourced from the OMINAS top directory.\n"
  return
fi



#-------------------------------------------------------------------------#
# Restore prior configuration, if one exists.  
#-------------------------------------------------------------------------#
if [ "$restore" == 1 ]; then 

  #- - - - - - - - - - - - - - - - - - - - - - - -#
  # abort if no backup dir
  #- - - - - - - - - - - - - - - - - - - - - - - -#
  if [ ! -d "$HOME/.ominas-restore" ]; then 
    printf "There is no saved configuration to restore.\n"
    return
  fi

  #- - - - - - - - - - - - - - - - - - - - - - - -#
  # swap .ominas and .ominas-restore
  #- - - - - - - - - - - - - - - - - - - - - - - -#
  printf "Swapping $setup_dir and $HOME/.ominas-restore/.\n"
  mv $HOME/.ominas-restore   $HOME/._ominas-restore
  if [ -d "$setup_dir" ]; then 
    mv $setup_dir $HOME/.ominas-restore
  fi
  mv $HOME/._ominas-restore $setup_dir

  return
fi




#-------------------------------------------------------------------------#
# Abort if OMINAS already installed unless -force.
#-------------------------------------------------------------------------#
if [ -d "$setup_dir" ]; then 
  #- - - - - - - - - - - - - - - - - - - - - - - -#
  # if -force, first make a backup
  #- - - - - - - - - - - - - - - - - - - - - - - -#
  if [ "$force" == 1 ]; then 

    #- - - - - - - - - - - - - - - - - - - - - - - - -#
    # Delete existing backup directory if it exists
    #- - - - - - - - - - - - - - - - - - - - - - - - -#
    if [ -d "$HOME/.ominas-restore" ]; then 
      printf "Deleting existing directory $HOME/.ominas-restore/.\n"
      yes|rm -r $HOME/.ominas-restore >& /dev/null
    fi

    #- - - - - - - - - - - - - - - - - - - - - - - - -#
    # Rename current configuration
    #- - - - - - - - - - - - - - - - - - - - - - - - -#
    printf "Saving current $setup_dir directory as $HOME/.ominas-restore/.\n"
     mv $setup_dir $HOME/.ominas-restore

  #- - - - - - - - - - - - - - - - - - - - - - - -#
  # abort if no -force switch
  #- - - - - - - - - - - - - - - - - - - - - - - -#
  else
    printf "OMINAS is already installed.  Use -force to overwrite configuration.\n"
    return
  fi
fi



#============================================================================#
# Set up new .ominas dir and run OMIN. 
#============================================================================#
printf "Starting new installation...\n"

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# call OMINAS module setup to set basic variables.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
. ./module/setup.sh

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# rest is done from install/ directory.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
cd ./install/

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# create OMINAS setup directory.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
printf "Creating setup directory\n"
mkdir -p $setup_dir
mkdir -p $setup_dir/profiles

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# copy default files to .ominas/
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
printf "Copying defaults\n"
cp $OMINAS_DIR/install/defaults/* $setup_dir


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# detect the IDL version ($idlversion) and location ($idlbin).
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
. ./code/detect_idl.sh


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# add ominasrc to .bashrc.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
if grep -q "^\. ~/\.ominas/ominasrc$" ~/.bashrc ; then
  echo ".bashrc already runs ominasrc."
else
  echo ". ~/.ominas/ominasrc" >> ~/.bashrc
fi


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# generate ominas script.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
. ./code/generate_ominas.sh


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# Return to OMINAS top directory.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
cd ../



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
# Start OMIN.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -#
. $setup_dir/ominasrc
omin :OMINAS_SETUP_DIR=$setup_dir




