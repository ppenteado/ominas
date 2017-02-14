#!/usr/bin/env bash
#script to download and prepare for use a copy of the SAO catalog from CDS
#Usage:
#./download_SAO.sh /directory/to/place/catalog


echo "This script wiill download the SAO catalog from CDS (ftp://cdsarc.u-strasbg.fr/pub/cats/I/131A) and prepare its files for use. As of January/2017, this adds to 19 MB of download, and 70 MB of disk space after unpacking."

read -rp "Continue? " ans
case $ans in
  [Nn]*)
    exit
esac

baseurl="ftp://cdsarc.u-strasbg.fr/pub/cats/I/131A"
#standard download (full, nonrecursive) directories

#location for timestamps files
mkdir -p ~/.ominas/timestamps/SAO

./pp_wget "${baseurl}/ --localdir=${1}/ --absolute --timestamps=~/.ominas/timestamps/ $@"

#unpack the catalog files
idl -e "file_gunzip,'$1'+path_sep()+'sao.dat.gz',/verbose"
