cat ./code/ominas_head.sh >> $setup_dir/ominas

if [ -e "/opt/X11/lib/flat_namespace/" ]; then
  cat <<LDCMD >> $setup_dir/ominas
    if [ "\${DYLD_LIBRARY_PATH}" = "" ]; then
        DYLD_LIBRARY_PATH="/opt/X11/lib/flat_namespace/"
    else
        DYLD_LIBRARY_PATH="/opt/X11/lib/flat_namespace/:\${DYLD_LIBRARY_PATH}"
    fi
LDCMD
fi
tail -n +2 ${idlbin} | sed -e "s/APPLICATION=\`basename \$0\`/APPLICATION=idl/g" >> $setup_dir/ominas
cat $setup_dir/ominas | sed -e "s|\"\$@\" \$APP_ARGS|-IDL_PROMPT \"'OMINAS\> '\" \"\${args[@]/#/}\" \$APP_ARGS |g" > $setup_dir/ominas_tmp
mv -f $setup_dir/ominas_tmp $setup_dir/ominas
if [ "${idlversion}" \< "linux84" ] && [ "${idlversion}" \> "linux" ]; then
  ldp="LD_PRELOAD=${OMINAS_DIR}/core/util/downloader/libcurl.so.4"
  cat $setup_dir/ominas | sed -e "s|exec |${ldp} exec |g" > $setup_dir/ominas_tmp
  mv -f $setup_dir/ominas_tmp $setup_dir/ominas
fi
chmod a+rx $setup_dir/ominas

#make ominasde script

echo "#!/usr/bin/env bash" > $setup_dir/ominasde

cat ${OMINAS_DIR}/config/bashcomments.txt >> $setup_dir/ominasde

#head -1 ${idlbin} > $setup_dir/ominasde
asetting=`eval echo ${setting}`
echo ". ${asetting}" >> $setup_dir/ominasde
echo "args=("\$@")" >> $setup_dir/ominasde
if [ -e "/opt/X11/lib/flat_namespace/" ]; then
  cat <<LDCMD >> $setup_dir/ominasde
    if [ "\${DYLD_LIBRARY_PATH}" = "" ]; then
        DYLD_LIBRARY_PATH="/opt/X11/lib/flat_namespace/"
    else
        DYLD_LIBRARY_PATH="/opt/X11/lib/flat_namespace/:\${DYLD_LIBRARY_PATH}"
    fi
LDCMD
fi
tail -n +2 ${idlbin} | sed -e "s/APPLICATION=\`basename \$0\`/APPLICATION=idlde/g" >> $setup_dir/ominasde
cat $setup_dir/ominasde | sed -e "s|\"\$@\" \$APP_ARGS|-IDL_PROMPT \"'OMINAS\> '\" \"\${args[@]/#/}\" \$APP_ARGS |g" > $setup_dir/ominasde_tmp
mv -f $setup_dir/ominasde_tmp $setup_dir/ominasde
if [ "${idlversion}" \< "linux84" ] && [ "${idlversion}" \> "linux" ]; then
  ldp="LD_PRELOAD=${OMINAS_DIR}/core/util/downloader/libcurl.so.4"
  cat $setup_dir/ominasde | sed -e "s|exec |${ldp} exec |g" > $setup_dir/ominasde_tmp
  mv -f $setup_dir/ominasde_tmp $setup_dir/ominasde
fi
chmod a+rx $setup_dir/ominasde
