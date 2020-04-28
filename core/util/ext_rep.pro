;==============================================================================
; ext_rep
;
;==============================================================================
function ext_rep, filename, new_ext, all=all

 dot = '.'
 if(NOT keyword_set(new_ext)) then dot = ''

 nfiles = n_elements(filename)
 new_fnames = filename

 w = where(new_fnames EQ '')

 for i=0, nfiles-1 do $
  begin
   ff = str_flip(filename[i])
   if(keyword_set(all)) then ss = str_nsplit(ff, '.') $
   else ss = str_split(ff, '.')
   nss = n_elements(ss)
   if(n_elements(ss) EQ 1) then new_fnames[i] = filename[i] + dot + new_ext $
   else new_fnames[i] = str_flip(ss[nss-1]) + dot + new_ext
  end

 if(w[0] NE -1) then new_fnames[w] = ''

 return, new_fnames
end
;==============================================================================


