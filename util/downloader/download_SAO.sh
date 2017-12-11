#!/usr/bin/env bash
#script to prepare for use the version of the SAO catalog distributed with OMINAS
#Usage:
#./download_SAO.sh /directory/to/place/catalog

echo ${1}/sao_idl.str
if [ ! -e ${1} ]; then
  echo "creating ${1}"
  mkdir -p ${1}
fi
if [ ! -e ${1}/sao_idl.str ]; then
  echo "making ${1}/sao_idl.str"
  ln -s ${OMINAS_DIR}/demo/data/sao_idl.str ${1}/sao_idl.str
fi
