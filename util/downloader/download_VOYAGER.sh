#!/usr/bin/env bash
#script to download a copy of the Voyager kernels from PDS
#Usage:
#./download_VOYAGER.sh /directory/to/place/kernels

OWNDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
wget=${OWNDIR}/pp_wget
echo "This script wiill download all kernels from the PDS Voyager archive ("\
"http://naif.jpl.nasa.gov/pub/naif/VOYAGER/kernels/. As of December/2016, this adds to 163 MB."


if [ -z ${ominas_auto+x} ] || [ ${ominas_auto} == 0 ] ; then
  read -rp "Continue?[y] " ans
  case $ans in
    [Nn]*)
      exit 1
  esac
fi


baseurl="http://naif.jpl.nasa.gov/pub/naif/VOYAGER/kernels/"
#standard download (full, nonrecursive) directories
dirs=( fk ik lsk pck sclk )

#location for timestamps files
mkdir -p ~/.ominas/timestamps/VOYAGER
ts=`eval echo "~/.ominas/timestamps/"`


for dir in "${dirs[@]}"
do
 ${wget} "${baseurl}${dir}/ --localdir=${1}/$dir/ --absolute --timestamps=$ts $@"
done

#special treatment directories (spk and ck, which are large)
echo "Downloading spks"
${wget} "${baseurl}spk/ --localdir=${1}/spk/ $@ --absolute --timestamps=$ts" # --xpattern=(\.bsp$)|(\.bsp\.lbl$)"

echo "Downloading cks"
${wget} "${baseurl}ck/ --localdir=${1}/ck/ $@ --absolute --timestamps=$ts"
#${wget} "${baseurl}ck/ --localdir=$1/ck/ $@ --absolute --timestamps=~/.ominas/timestamps/ --xpattern="\
#"(\.tar\.gz$)|([[:digit:]]{5}_[[:digit:]]{5}[[:alnum:]]{2}(_(S|C)[[:digit:]]{2})?\.((pdf)|(txt))$)|(_bc_err\.txt$)" #--xpattern=(\.bc$)|(bc\.lbl$)|"

#${wget} "${baseurl}ck/ --localdir=$1/ck/ $@ --absolute --timestamps=~/.ominas/timestamps/CASSINI/ck.json --pattern="\
#"([[:digit:]]{5}_[[:digit:]]{5}(r[[:alnum:]])|([[:alnum:]]{2}_ISS))(\.bc$)|(bc\.lbl$)"

#generic lsk and pck, because these are empty in Voyager
baseurl="http://naif.jpl.nasa.gov/pub/naif/generic_kernels/"
dirs=( lsk pck )

#location for timestamps files
mkdir -p ~/.ominas/timestamps/GENERIC

for dir in "${dirs[@]}"
do
 ${wget} "${baseurl}${dir}/ --localdir=${1}/../Generic_kernels/$dir/ --absolute $@"
done

#cks from rings node
cks=( vg1_jup_version1_type1_iss_sedr.txt vg1_jup_version1_type1_iss_sedr.bc vg2_jup_version1_type1_iss_sedr.txt vg2_jup_version1_type1_iss_sedr.bc vg1_sat_version1_type1_iss_sedr.txt vg1_sat_version1_type1_iss_sedr.bc V1SAT_VERSION2_TYPE3_UVS_SEDR.txt 1SAT_VERSION2_TYPE3_UVS_SEDR.ck V1SAT_VERSION3_TYPE3_MERGED_SEDR.txt V1SAT_VERSION3_TYPE3_MERGED_SEDR.ck V1SAT_VERSION4_TYPE1_ISS_CSMITHED.txt V1SAT_VERSION4_TYPE1_ISS_CSMITHED.ck V1SAT_VERSION5_TYPE3_MERGED_CSMITHED.txt V1SAT_VERSION5_TYPE3_MERGED_CSMITHED.ck vg2_sat_version1_type1_iss_sedr.txt vg2_sat_version1_type1_iss_sedr.bc vg2_ura_version1_type1_iss_sedr.txt vg2_ura_version1_type1_iss_sedr.bc vg2_nep_version1_type1_iss_sedr.txt vg2_nep_version1_type1_iss_sedr.bc )

ckb=http://pds-rings.seti.org/voyager/ck/

for f in "${cks[@]}"
do
  ${wget} " ${ckb}${f} --localdir=${1}/ck/ --absolute $@"
done


