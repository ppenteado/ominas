#!/bin/csh
# uninstall.csh
#------------------------------------------------------------------------------#
#	OMINAS uninstaller for (t)csh 											   #
#	This script runs the uninstallation process for OMINAS. It removes 		   #
#	the script entries for OMINAS and environment variables from the		   #
#	cshrc. It also removes all OMINAS files from the host computer.	  		   #
#------------------------------------------------------------------------------#

printf "This script will uninstall OMINAS and remove its contents from your device.\n"
printf "Please confirm that you would like to uninstall OMINAS (y/n)  "
set ans = $<
if ! ( $ans == [Yy]* ) exit 1

set setting = "$HOME/.cshrc"

grep -v '.*ominas_env_.*' $setting >& $HOME/temp
mv $HOME/temp $setting
grep -v "setenv OMINAS_DIR ${OMINAS_DIR}" $setting >& $HOME/temp
mv $HOME/temp $setting
#rm -rf $OMINAS_DIR

printf "Uninstallation of OMINAS is complete. Please restart your terminal session.\n"