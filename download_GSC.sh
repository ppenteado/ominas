#!/usr/bin/env bash
#script to download and prepare for use a copy of the GSC 1.2 catalog from CDS
#Usage:
#./download_GSC.sh /directory/to/place/catalog


echo "This script wiill download the GSC 1.2 catalog from CDS (http://cdsarc.u-strasbg.fr/ftp/cats/bincats/GSC_1.2/) and prepare its files for use. As of January/2017, this adds to 8.5 GB"

read -rp "Continue? " ans
case $ans in
  [Nn]*)
    exit 1
esac



baseurl="http://cdsarc.u-strasbg.fr/ftp/cats/bincats/GSC_1.2/"

#standard download (full, nonrecursive) directories

#location for timestamps files
mkdir -p ~/.ominas/timestamps/GSC

./pp_wget "${baseurl}/ --localdir=$1/${dir}/ --absolute --timestamps=~/.ominas/timestamps/ $@"

#process the files
idl -e '!path+=":./util/downloader"& unpack_gsc12' -args $@
