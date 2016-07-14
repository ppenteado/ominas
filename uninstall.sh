#!/usr/bin/env bash
# uninstall.sh
#------------------------------------------------------------------------------#
#	OMINAS uninstaller for bash 											   #
#	This script runs the uninstallation process for OMINAS. It removes 		   #
#	the script entries for OMINAS and environment variables from the		   #
#	bash_profile. It also removes all OMINAS files from the host computer.	   #
#------------------------------------------------------------------------------#

printf "This script will uninstall OMINAS and remove its contents from your device.\n"
read -rp "Please confirm that you would like to uninstall OMINAS (y/n)  " ans
if ! [[ $ans == [Yy]* ]]; then
	exit 1
fi

if [ -f ~/.bash_profile ]; then
	setting="$HOME/.bash_profile"
else
	if [ -f ~/.bashrc ]; then
		setting="$HOME/.bashrc"
	else
		printf "Settings file not found...\n"
	fi
fi

grep -v '.*ominas_env_.*' $setting >$HOME/temp
mv $HOME/temp $setting
grep -v "OMINAS_DIR=${OMINAS_DIR}; export OMINAS_DIR" $setting >$HOME/temp
mv $HOME/temp $setting

cat <<IDLCMD >unins.bat
p=pref_get('IDL_PATH')
p=strsplit(p,':',/extract)
p=p[where(strpos(p,'icy')eq-1)]
p=p[where(strpos(p,'$OMINAS_DIR')eq-1)]
p=p[where(strpos(p,'$XIDL_DIR')eq-1)]
p=strjoin(p,':')
pref_set,'IDL_PATH',p,/commit
d=pref_get('IDL_DLM_PATH')
d=strsplit(d,':',/extract)
d=d[where(strpos(d,'icy')eq-1)]
d=strjoin(d,':')
pref_set,'IDL_DLM_PATH',d,/commit
exit
IDLCMD

$IDL_DIR/idl/bin/idl unins.bat

#rm -rf $OMINAS_DIR

printf "Uninstallation of OMINAS is complete. Please restart your terminal session.\n"
