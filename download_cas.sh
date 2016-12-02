#!/usr/bin/env bash
#script to download a copy of the Cassini kernels from PDS

baseurl="http://naif.jpl.nasa.gov/pub/naif/CASSINI/kernels/"
#standard download (full, nonrecursive) directories
dirs=( fk ik lsk pck sclk )

#location for timestamps files
mkdir -p ~/.ominas/timestamps/cas

for dir in "${dirs[@]}"
do
 ./pp_wget "${baseurl}${dir}/ --localdir=$1/${dir}/ --absolute --timestamps=~/.ominas/timestamps/cas/${dir}.json $@"
done

#special treatment directories (spk and ck, which are large)
echo "Downloading spks"
./pp_wget "${baseurl}spk/ --localdir=$1/spk/ $@ --absolute --timestamps=~/.ominas/timestamps/cas/spk.json" # --xpattern=(\.bsp$)|(\.bsp\.lbl$)"

echo "Downloading cks"
#./pp_wget "${baseurl}ck/ --localdir=$1/ck/ $@ --absolute --timestamps=~/.ominas/timestamps/cas/ck.json --xpattern="\
#"(\.tar\.gz$)|([[:digit:]]{5}_[[:digit:]]{5}[[:alnum:]]{2}(_(S|C)[[:digit:]]{2})?\.((pdf)|(txt))$)|(_bc_err\.txt$)" #--xpattern=(\.bc$)|(bc\.lbl$)|"

./pp_wget "${baseurl}ck/ --localdir=$1/ck/ $@ --absolute --timestamps=~/.ominas/timestamps/cas/ck.json --pattern="\
"([[:digit:]]{5}_[[:digit:]]{5}(r[[:alnum:]])|([[:alnum:]]{2}_ISS))(\.bc$)|(bc\.lbl$)"
