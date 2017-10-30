;===========================================================================
; detect_pds.pro
;
;===========================================================================
function __detect_pds, dd

 filename = dat_filename(dd)
 status=0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string

 ;=================================
 ; check the first few characters
 ;=================================
 record = assoc(unit, bytarr(160,/nozero))
 s = string(record[0])
 if(strpos(s,'PDS_VERSION_ID') NE -1) then status = 1
 if(strpos(s,'SFDU_LABEL') NE -1) then status = 1
 if(strpos(s,'XV_COMPATIBILITY') NE -1) then status = 1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit

 return, status
end
;===========================================================================



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
   if(error NE 0) then nv_message, /anonymous, !err_string
   record = assoc(unit, bytarr(160,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end


 ;===================================
 ; check for pds label 
 ;===================================
 if(strpos(s,'PDS_VERSION_ID') NE -1) then status = 1
 if(strpos(s,'SFDU_LABEL') NE -1) then status = 1
 if(strpos(s,'XV_COMPATIBILITY') NE -1) then status = 1


 return, status
end
;===========================================================================
