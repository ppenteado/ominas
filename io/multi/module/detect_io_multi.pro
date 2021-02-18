;===========================================================================
; detect_io_multi.pro
;
;===========================================================================
function detect_io_multi, dd, arg, query=query
 if(keyword_set(query)) then return, 'FILETYPE'

 status = 0

 ;===============================================
 ; if no header, read the beginning of the file
 ;===============================================
 if(keyword_set(arg.header)) then s = arg.header $
 else $
  begin
   openr, unit, arg.filename, /get_lun, error=error
   if(error NE 0) then return, 0
   if((fstat(unit)).size LT 11) then return, 0
   record = assoc(unit, bytarr(11,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end


 ;===================================
 ; check for indicator string
 ;===================================
 if ~isa(s,'string') then return,0
 if(s[0] EQ '___MULTI___') then status = 1


 if(status) then return, 'MULTI'
 return, 0
end
;===========================================================================
