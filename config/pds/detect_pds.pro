;===========================================================================
; detect_pds.pro
;
;===========================================================================
function detect_pds, dd

 filename = dat_filename(dd)
 header = dat_header(dd)
 status = 0

 ;===============================================
 ; if no header, read the beginning of the file
 ;===============================================
 if(keyword_set(header)) then s = header $
 else $
  begin
   openr, unit, filename, /get_lun, error=error
   if(error NE 0) then return, 0
   record = assoc(unit, bytarr(160,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end


 ;===================================
 ; check for pds label 
 ;===================================
 if(strpos(s[0], 'PDS_VERSION_ID') NE -1) then status = 1
 if(strpos(s[0], 'SFDU_LABEL') NE -1) then status = 1
 if(strpos(s[0], 'XV_COMPATIBILITY') NE -1) then status = 1


 return, status
end
;===========================================================================
