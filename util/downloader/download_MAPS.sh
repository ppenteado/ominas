#!/usr/bin/env bash
#script to download and prepare for use a copy of the OMINAS maps from Github
#Usage:
#./download_MAPS.sh /directory/to/place/catalog

OWNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wget=${OWNDIR}/pp_wget
echo "This script wiill download the OMINAS maps package from Github (https://github.com/ppenteado/ominas_maps). As of August/2017, this adds to  MB of download,"


if [ -z ${ominas_auto+x} ] || [ ${ominas_auto} == 0 ] ; then
  read -rp "Continue?[y] " ans
  case $ans in
    [Nn]*)
      exit 1
  esac
fi

baseurl="https://github.com/ppenteado/ominas_maps"
#standard download (full, nonrecursive) directories

#location for timestamps files
mkdir -p ~/.ominas/timestamps/
ts=`eval echo "~/.ominas/timestamps/"`

if [ ! -d ${1} ]; then
  git clone https://github.com/ppenteado/ominas_maps ${1}
else
  echo "${1} already exists; skipping git clone, since it requires the destination to be empty"
fi
#${wget} "${baseurl}/ --localdir=${1}/ --absolute --timestamps=$ts $@"



