#!/usr/bin/env bash
#script to download and prepare for use a copy of the SEDR data
#Usage:
#./download_SEDR.sh /directory/to/place/catalog

OWNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wget=${OWNDIR}/pp_wget
echo "SEDR data download not yet implemented"

#read -rp "Continue? " ans
#case $ans in
#  [Nn]*)
#    exit 1
#esac

#baseurl="ftp://cdsarc.u-strasbg.fr/pub/cats/I/131A"
#standard download (full, nonrecursive) directories

#location for timestamps files
mkdir -p ~/.ominas/timestamps/SEDR
ts=`eval echo "~/.ominas/timestamps/"`

mkdir -p ${1}
#${wget} "${baseurl}/ --localdir=${1}/ --absolute --timestamps=$ts $@"

