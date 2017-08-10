#!/usr/bin/env bash
#script to prepare for use the version of the SAO catalog distributed with OMINAS
#Usage:
#./download_SAO.sh /directory/to/place/catalog

if [ ! -e ${1}/sao_idl.str ]; then
  ln -s ${OMINAS_DIR}/demo/data/sao_idl.str ${1}/sao_idl.str
fi
