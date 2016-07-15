;===========================================================================
; pp_detect_isis.pro
;
;===========================================================================
function pp_detect_isis, filename, udata

 status=0

 ;==============================
 ; open the file
 ;==============================
 openr, unit, filename, /get_lun, error=error
 if(error NE 0) then nv_message, !err_string

 ;=================================
 ; read the first four characters
 ;=================================
 record = assoc(unit, bytarr(4,/nozero))
 s = string(record[0])
 if(strpos(s, 'CCSD') EQ 0) then status=1

 ;==============================
 ; close config file
 ;==============================
 close, unit
 free_lun, unit


 return, status
end
;===========================================================================
