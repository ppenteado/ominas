# add ICY to IDL_PATH if not present
export OMINAS_LIB_ICY_LIB=$OMINAS_ICY_DATA/lib
###if [ `echo $IDL_PATH | grep -Eco "$OMINAS_LIB_ICY_LIB/?(:|$)"` == 0 ]; then export IDL_PATH="${IDL_PATH:+$IDL_PATH:}+OMINAS_LIB_ICY_LIB"; fi
