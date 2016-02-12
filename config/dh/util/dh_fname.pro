;=============================================================================
; dhfn_findfile
;
;=============================================================================
function dhfn_findfile, dir, name, ext

 ;---------------------------------------------------------------
 ; try replacing existing extension
 ;---------------------------------------------------------------
 ff = findfile(dir + '/' + name + '.dh')
 if(keyword_set(ff)) then return, ff

 ;---------------------------------------------------------------
 ; try just adding .dh extension
 ;---------------------------------------------------------------
 if(keyword_set(ext)) then ff = findfile(dir + '/' + name + '.' + ext + '.dh')
 if(keyword_set(ff)) then return, ff


 return, ''
end
;=============================================================================



;=============================================================================
; dh_fname.pro
;
;=============================================================================
function dh_fname, filename
 return, ext_rep(filename, 'dh')

 split_filename, filename, dir, name, ext

 ;---------------------------------------------------------------
 ; try same directory as the image
 ;---------------------------------------------------------------
 ff = dhfn_findfile(dir, name, ext)
 if(keyword_set(ff)) then return, ff

 ;---------------------------------------------------------------
 ; try current directory
 ;---------------------------------------------------------------
 ff = dhfn_findfile('./', name, ext)
 if(keyword_set(ff)) then return, ff

 ;---------------------------------------------------------------
 ; try DH_PATH
 ;---------------------------------------------------------------
 path = getenv('DH_PATH')
 if(keyword_set(path)) then $
  begin
   ff = dhfn_findfile(path, name, ext)
   if(keyword_set(ff)) then return, ff
  end


 return, ''
end
;=============================================================================


