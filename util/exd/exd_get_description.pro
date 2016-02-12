;==============================================================================
; exd_get_description
;
;==============================================================================
function exd_get_description, dir


 desc_file = 'description.html'
 ff = findfile(dir + '/' + desc_file)
 if(NOT keyword_set(ff)) then $
  begin
   desc_file = 'description.txt'
   ff = findfile(dir + '/' + desc_file)
   if(NOT keyword_set(ff)) then desc_file = ''
  end


 return, desc_file
end
;==============================================================================
