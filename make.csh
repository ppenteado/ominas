############################################################################
# make.csh
# 
#  Compiles core ominas idl code (not the translators).
#
############################################################################
set files = `ls -f ./util/*.pro ./util/*/*.pro ./util/*/*/*.pro \
             ./nv/gr/*.pro ./nv/gr/*/*.pro \
             ./nv/sys/*.pro ./nv/sys/*/*.pro \
             ./nv/lib*.pro ./nv/lib*/*.pro ./nv/lib*/*/*.pro ./nv/lib*/*/*/*.pro \
             ./nv/lib*/*/*/*/*.pro \
             ./nv/com/*.pro ./nv/com/*/*.pro ./nv/com/*/*/*.pro ./nv/com/*/*/*/*.pro \
             | grep -v /old/ | grep -v /doc_ |grep -v compile_ |grep -v ~` 

rm -f compile_ominas.pro
echo '; ominas compilation script' > compile_ominas.pro
echo .rnew grim >> compile_ominas.pro

foreach file ($files)
 echo .rnew $file >> compile_ominas.pro
end

foreach file ($files)
 echo .rnew $file >> compile_ominas.pro
end

cat _compile_ominas.pro >> compile_ominas.pro


idl compile_ominas.pro

csh ./compile_doc.csh

rm -f cdate
date +%x > cdate
############################################################################
