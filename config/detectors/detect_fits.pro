;===========================================================================
; detect_fits.pro
;
;===========================================================================
function detect_fits, filename, udata

 status=0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, !err_string

 ;=================================
 ; read the first thirty characters
 ;=================================
 record = assoc(unit, bytarr(6,/nozero))
 s=string(record[0])
 if(s EQ 'SIMPLE') then status=1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 return, status
end
;===========================================================================
