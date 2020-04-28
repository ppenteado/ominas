# Merge GRIM resource file with main .Xdefaults file
#The following line, to load the new Xdefaults definition, is commented to avoid problems in systems where xrdb is not available.
#If you would like to enable it, copy this line to you ~/.bashrc  /  ~/.bash_profile
#Uncommenting that line here n ominas_setup.sh is not recommended, as this file will be overwritten the next time you use configure.sh
#!!!! should be able to test for X system here
#xrdb -merge $HOME/.ominas/Xdefaults-grim

# OMINAS basic environment variables
export OMINAS_DIR=$HOME/ominas
export OMINAS_DATA=$HOME/ominas_data
export OMINAS_RC=$HOME/.ominas

export OMINAS_TMP=/tmp/_${HOME}_ominas
if [ ! -w $OMINAS_TMP ]; then mkdir -p $OMINAS_TMP; fi
