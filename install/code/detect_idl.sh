#---------------------------------------------------------------------------#
# detect IDL location
#---------------------------------------------------------------------------#
if [ "$IDL_DIR" = "" ]; then
        ivers=( "idl87" "idl86" "idl85" "idl84" "idl83" "idl82" "idl" )
        for idlbinv in "${ivers[@]}"; do
          idl=`which ${idlbinv} | tail -1`
          echo ${idlbinv}
          idlbin=$idl
          if [ "$idl" != "" ]; then break; fi
        done
        if [ "$idl" = "" ]; then
          read -rp "IDL not found. Please enter the location of your IDL installation (such as /usr/local/exelis/idl85): " idldir
          IDL_DIR="$idldir"
          export IDL_DIR
          printf "Using IDL from $IDL_DIR\n"
          idlbin=$IDL_DIR/bin/idl
        else
          printf "Using IDL at $idl\n"
          IDL_DIR=`${idl} -e 'print,filepath("")' | tail -1`
          printf "Setting IDL_DIR to ${IDL_DIR}\n"
          export IDL_DIR
          idlbin=$IDL_DIR/bin/idl
        fi
else
        printf "IDL_DIR found, $IDL_DIR, using it\n"
        idlbin=$IDL_DIR/bin/idl
fi

bintest=`echo ${idlbin} | grep -c "/bin/bin\."`
if [ ${bintest} != 0 ]; then
  idlbin=`dirname ${idlbin}`
  idlbin=`dirname ${idlbin}`
  idlbin="${idlbin}/idl"
fi 
export idlbin

#---------------------------------------------------------------------------#
# detect IDL version
#---------------------------------------------------------------------------#
idlversion=`$idlbin -e 'print,!version.os+strjoin((strsplit(!version.release,".",/extract))[0:1])'`
export idlversion
