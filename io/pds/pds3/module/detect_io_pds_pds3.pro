;===========================================================================
; detect_io_pds_pds3.pro
;
;===========================================================================
function detect_io_pds_pds3, dd, arg, query=query
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
   if((fstat(unit)).size LT 160) then return, 0
   record = assoc(unit, bytarr(160,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end


 ;===================================
 ; check for pds label 
 ;===================================
 if ~isa(s,'string') then return,0
 if(strpos(s[0], 'PDS_VERSION_ID') NE -1) then status = 1
 if(strpos(s[0], 'SFDU_LABEL') NE -1) then status = 1
 if(strpos(s[0], 'XV_COMPATIBILITY') NE -1) then status = 1


 if(status) then return, 'PDS3'
 return, 0
end
;===========================================================================