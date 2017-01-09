#!/usr/bin/env bash
#script to download a copy of the Voyager kernels from PDS
#Usage:
#./download_VOYAGER.sh /directory/to/place/kernels


echo "This script wiill download all kernels from the PDS Voyager archive ("\
"http://naif.jpl.nasa.gov/pub/naif/VOYAGER/kernels/. As of December/2016, this adds to 163 MB."

read -rp "Continue? " ans
case $ans in
  [Nn]*)
    exit
esac

baseurl="http://naif.jpl.nasa.gov/pub/naif/VOYAGER/kernels/"
#standard download (full, nonrecursive) directories
dirs=( fk ik lsk pck sclk )

#location for timestamps files
mkdir -p ~/.ominas/timestamps/VOYAGER

for dir in "${dirs[@]}"
do
 ./pp_wget "${baseurl}${dir}/ --localdir=$1/${dir}/ --absolute --timestamps=~/.ominas/timestamps/ $@"
done

#special treatment directories (spk and ck, which are large)
echo "Downloading spks"
./pp_wget "${baseurl}spk/ --localdir=$1/spk/ $@ --absolute --timestamps=~/.ominas/timestamps/" # --xpattern=(\.bsp$)|(\.bsp\.lbl$)"

echo "Downloading cks"
./pp_wget "${baseurl}ck/ --localdir=$1/ck/ $@ --absolute --timestamps=~/.ominas/timestamps/"
#./pp_wget "${baseurl}ck/ --localdir=$1/ck/ $@ --absolute --timestamps=~/.ominas/timestamps/ --xpattern="\
#"(\.tar\.gz$)|([[:digit:]]{5}_[[:digit:]]{5}[[:alnum:]]{2}(_(S|C)[[:digit:]]{2})?\.((pdf)|(txt))$)|(_bc_err\.txt$)" #--xpattern=(\.bc$)|(bc\.lbl$)|"

#./pp_wget "${baseurl}ck/ --localdir=$1/ck/ $@ --absolute --timestamps=~/.ominas/timestamps/CASSINI/ck.json --pattern="\
#"([[:digit:]]{5}_[[:digit:]]{5}(r[[:alnum:]])|([[:alnum:]]{2}_ISS))(\.bc$)|(bc\.lbl$)"