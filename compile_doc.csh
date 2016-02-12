############################################################################
# compile_doc
#
# Descends MINAS directory tree running docidl in each appropriate directory.
# If a makefile is found in a directory then 'make' is run.
# Also compiles all minas idl code and documentation
# 
# Run this script from the minas top directory.
#
############################################################################
set dirs = `ls -1F | grep / | sed 's/\// /'`
echo $dirs

foreach i ($dirs)
 if($i != old && $i != obsolete && $i != admin && $i != bak && $i != doc \
     && $i != demo && $i != data && $i != bin) then
  echo $i
  cd $i
  csh ${OMINAS_DIR}/docidl.csh 
  csh ${OMINAS_DIR}/compile_doc.csh -nocompile
  cd ..
 endif
end


if($#argv == 0) then
 idl doc_ominas.bat

 cd doc/
 csh ./make_doc_links
 cd ..
endif


############################################################################
