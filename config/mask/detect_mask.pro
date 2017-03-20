;===========================================================================
; detect_mask.pro
;
;===========================================================================
function detect_mask, dd

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
