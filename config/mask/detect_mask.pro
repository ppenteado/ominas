;===========================================================================
; detect_mask.pro
;
;===========================================================================
function ___detect_mask, dd

 filename = dat_filename(dd)
 status = 0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, /anonymous, !err_string

 ;=================================
 ; read the first four characters
 ;=================================
 record = assoc(unit, bytarr(4,/nozero))
 s = string(record[0])
 if(s EQ 'mask') then status=1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 return, status
end
;===========================================================================



;===========================================================================
; detect_mask.pro
;
;===========================================================================
function detect_mask, dd

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
   record = assoc(unit, bytarr(4,/nozero))
   s = string(record[0])
   close, unit
   free_lun, unit
  end



 ;===================================
 ; check for indicator string
 ;===================================
 if(s EQ 'mask') then status=1


 return, status
end
;===========================================================================
