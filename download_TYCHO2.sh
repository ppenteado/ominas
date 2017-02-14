#!/usr/bin/env bash
#script to download and prepare for use a copy of the Tycho 2 catalog from CDS
#Usage:
#./download_TYCHO2.sh /directory/to/place/catalog


echo "This script wiill download the Tycho 2 catalog from CDS (ftp://cdsarc.u-strasbg.fr/pub/cats/I/259) and prepare its files for use. As of January/2017, this adds to 161 MB of download, and 665 MB of disk space after unpacking."

read -rp "Continue? " ans
case $ans in
  [Nn]*)
    exit
esac

baseurl="ftp://cdsarc.u-strasbg.fr/pub/cats/I/259"
baseurl="ftp://vizier.nao.ac.jp/pub/cats/I/259"
#standard download (full, nonrecursive) directories

#location for timestamps files
mkdir -p ~/.ominas/timestamps/
ts=`eval echo "~/.ominas/timestamps/"`

./pp_wget "${baseurl}/ --localdir=${1}/ --absolute --timestamps=$ts $@"

#unpack the catalog files
idl -e '!path+=":./util/downloader"& unpack_tycho2' -args $@
