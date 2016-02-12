;=============================================================================
; new_files
;
;
;=============================================================================
function new_files, files, path=path, ext=ext

 test_files = files

 if(keyword_set(path)) then $
  begin
   split_filename, files, dirs, names
   test_files = path[0] + '/' + names
  end

 if(keyword_set(ext)) then test_files = ext_rep(test_files, ext)

 ff = findfiles(test_files)
 w = where(ff EQ '')

 if(w[0] EQ -1) then return, ''

 return, files[w]
end
;=============================================================================
