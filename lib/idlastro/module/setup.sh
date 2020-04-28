# add idlastro an to IDL_PATH if not present
export OMINAS_LIB_IDLASTRO_PRO=OMINAS_LIB_IDLASTRO/pro
###if [ `echo $IDL_PATH | grep -Eco "$OMINAS_LIB_IDLASTRO_PRO/?(:|$)"` == 0 ]; then export IDL_PATH="${IDL_PATH:+$IDL_PATH:}+$OMINAS_LIB_IDLASTRO_PRO"; fi
