#!/usr/bin/env bash
#script to download a copy of the NAIF Generic kernels from PDS
#Usage:
#./download_GENERIC.sh /directory/to/place/kernels


echo "This script wiill download all kernels from the PDS Galileo archive ("\
"http://naif.jpl.nasa.gov/pub/naif/generic_kernels/. As of December/2016, this adds to 22GB."

read -rp "Continue? " ans
case $ans in
  [Nn]*)
    exit
esac

baseurl="http://naif.jpl.nasa.gov/pub/naif/generic_kernels/"
#standard download (full, nonrecursive) directories
dirs=( dsk fk lsk pck stars)

#location for timestamps files
mkdir -p ~/.ominas/timestamps/GENERIC

for dir in "${dirs[@]}"
do
 ./pp_wget "${baseurl}${dir}/ --localdir=${1}/$dir/ --absolute --timestamps=~/.ominas/timestamps/ --recursive$@"
done

#special treatment directories (spk and ck, which are large)
echo "Downloading spks"
./pp_wget "${baseurl}spk/ --localdir=${1}/spk/ $@ --absolute --timestamps=~/.ominas/timestamps/ --recursive" # --xpattern=(\.bsp$)|(\.bsp\.lbl$)"

