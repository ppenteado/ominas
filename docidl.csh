############################################################################
# docidl
#
#  Constructs idl batch files to extract documentation from
#  every program in the current directory.
#
#  Note that program names cannot contain the string "compile_" or "doc_"
#
############################################################################


############################################################################
# compilation -- this is obsolete.  make.csh takes care of compilation
############################################################################
pwd
setenv NAME `basename $PWD | awk '{print "compile_" $1 ".pro"}'`

rm -f $NAME

ls -1 *.pro | grep -v compile_ | grep -v doc_ | grep -v minas.pro | \
                                             awk '{print ".rnew", $1}' > $NAME

ls -1F | grep / | sed 's/\// /' \
         | grep -v old | grep -v bak | grep -v debug | grep -v doc \
         | grep -v demo | grep -v data | grep -v obsolete | \
                                        awk '{print "@compile_" $1}' >> $NAME

if($NAME == compile_minas.pro) then
 echo "resolve_all" 					>> $NAME
 echo "path = getenv('OMINAS_DIR')"			>> $NAME
 echo "save, /routines, filename=path+'minas.sav'"	>> $NAME
 echo "exit"						>> $NAME
endif


############################################################################
# documentation
############################################################################
setenv NAME `basename $PWD | awk '{print "doc_" $1 ".pro"}'`
setenv TITLE `basename $PWD | awk '{print toupper($1) " Program Reference"}'`

rm -f $NAME

echo extract_doc, /page, '$' > $NAME
echo "   " title='"'$TITLE'"', '$' >> $NAME
echo "   " '"'$PWD/"*.pro"'"', '$' >> $NAME
echo "   " '"'$PWD/`basename $PWD | awk '{print "doc_" $1 ".txt"}'`'"' >> $NAME

ls -1F | grep / | sed 's/\// /' \
         | grep -v old | grep -v bak | grep -v debug | grep -v doc \
         | grep -v demo | grep -v data | grep -v obsolete | \
                                            awk '{print "@doc_" $1}' >> $NAME

if($NAME == doc_ominas.pro) then
 echo "exit"						>> $NAME
endif

